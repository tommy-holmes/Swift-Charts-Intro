import SwiftUI
import Charts

struct CandleStickMark: ChartContent {
    let timestamp: PlottableValue<Date>
    let open: PlottableValue<Decimal>
    let high: PlottableValue<Decimal>
    let low: PlottableValue<Decimal>
    let close: PlottableValue<Decimal>
    
    var body: some ChartContent {
        BarMark(
            x: timestamp,
            yStart: open,
            yEnd: close,
            width: 4
        )
        BarMark(
            x: timestamp,
            yStart: high,
            yEnd: low,
            width: 1
        )
    }
}

struct CandleStickMark_Previews: PreviewProvider {
    private static let mock = StockPrice.mock
    
    static var previews: some View {
        Chart {
            CandleStickMark(
                timestamp: .value("Date", mock.timestamp),
                open: .value("Open", mock.open),
                high: .value("High", mock.high),
                low: .value("Low", mock.low),
                close: .value("Close", mock.close)
            )
            .foregroundStyle(mock.open < mock.close ? .blue : .red)
        }
    }
}
