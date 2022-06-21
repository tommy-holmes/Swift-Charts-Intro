import SwiftUI
import Charts

struct QuotesChart: View {
    private enum Unit: Identifiable {
        case forwardPE
        case trailingPE
        case askPrice
        case bidPrice
        
        var id: Self { self }
    }
    @State private var selectedUnit: Unit = .forwardPE
    
    private var stocks: [StockQuote] = Quotes.mock.stocks
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Unit", selection: $selectedUnit.animation(.easeInOut)) {
                Text("Foward P/E").tag(Unit.forwardPE)
                Text("Trailing P/E").tag(Unit.trailingPE)
                Text("Ask Price").tag(Unit.askPrice)
                Text("Bid Price").tag(Unit.bidPrice)
            }
            .pickerStyle(.segmented)
            
            Chart(stocks.sorted { yValue(for: $0) > yValue(for: $1) }) {
                BarMark(
                    x: .value("Values", yValue(for: $0)),
                    y: .value("Stock", $0.shortName)
                )
            }
            .frame(minHeight: 300)
        }
    }
}

private extension QuotesChart {
    func yValue(for stock: StockQuote) -> Double {
        switch selectedUnit {
        case .forwardPE: return stock.forwardPE
        case .trailingPE: return stock.trailingPE
        case .askPrice: return stock.ask
        case .bidPrice: return stock.bid
        }
    }
}

struct QuotesChart_Previews: PreviewProvider {
    static var previews: some View {
        QuotesChart()
    }
}
