import SwiftUI
import Charts

struct PriceChart: View {
    private enum Symbol: String, CaseIterable {
        case apple = "AAPL"
        case microsoft = "MSFT"
        case ibm = "IBM"
        case amd = "AMD"
    }
    private var currentPrices: [StockPrice] {
        Stock
            .mocks
            .first(where: { $0.metaData.symbol == selectedSymbol.rawValue })!
            .prices
    }
    private var dateBins: DateBins {
        .init(
            unit: .month,
            range: currentPrices[0].timestamp...currentPrices[currentPrices.count - 1].timestamp
        )
    }
    @State private var selectedSymbol: Symbol = .apple
    @State private var selectedPrice: StockPrice?
    @State private var annotationOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Stock", selection: $selectedSymbol.animation(.easeInOut)) {
                Text("AAPL").tag(Symbol.apple)
                Text("MSFT").tag(Symbol.microsoft)
                Text("IBM").tag(Symbol.ibm)
                Text("AMD").tag(Symbol.amd)
            }
            .pickerStyle(.segmented)
            
            Chart(currentPrices) { (price: StockPrice) in
                CandleStickMark(
                    timestamp: .value("Date", price.timestamp),
                    open: .value("Open", price.open),
                    high: .value("High", price.high),
                    low: .value("Low", price.low),
                    close: .value("Close", price.close)
                )
                .foregroundStyle(price.open < price.close ? .blue : .red)
                
                if let selectedPrice {
                    RuleMark(x: .value("Selected Date", selectedPrice.timestamp))
                        .foregroundStyle(.gray.opacity(0.3))
                        .annotation(position: .top, alignment: .center) {
                            PriceAnnotation(for: selectedPrice)
                                .offset(x: annotationOffset)
                        }
                }
            }
            .frame(minHeight: 300)
            .chartYAxis { AxisMarks(preset: .extended) }
            .chartOverlay { proxy in
                GeometryReader { g in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let xCurrent = value.location.x - g[proxy.plotAreaFrame].origin.x
                                    let plotWidth = proxy.plotAreaSize.width
                                    let upperBound = plotWidth * 0.7
                                    let lowerBound = plotWidth * 0.4
                                    
                                    if (upperBound...plotWidth).contains(xCurrent) {
                                        annotationOffset = upperBound - xCurrent
                                    } else if (0...lowerBound).contains(xCurrent) {
                                        annotationOffset = lowerBound - xCurrent
                                    } else {
                                        annotationOffset = 0
                                    }
                                    
                                    if let currentDate: Date = proxy.value(atX: xCurrent) {
                                        let index = dateBins.index(for: currentDate)
                                        
                                        if currentPrices.indices.contains(index) {
                                            selectedPrice = currentPrices[index]
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    selectedPrice = nil
                                    annotationOffset = 0
                                }
                        )
                }
            }
        }
    }
}

struct StockChart_Previews: PreviewProvider {
    static var previews: some View {
        PriceChart()
            .frame(height: 300)
    }
}
