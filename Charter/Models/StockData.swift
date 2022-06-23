import Foundation

struct StockData: Decodable {
    let chart: ChartData
}

struct ChartData: Decodable {
    let stocks: [Stock]
    
    enum CodingKeys: String, CodingKey {
        case stocks = "result"
    }
}

struct Stock: Decodable {
    let metaData: Meta
    let timestamp: [TimeInterval]
    let indicators: Indicators
    
    enum CodingKeys: String, CodingKey {
        case metaData = "meta"
        case timestamp, indicators
    }
}

struct Meta: Decodable {
    let currency: String
    let symbol: String
    let dataGranularity: String
    let range: String
}

struct Indicators: Decodable {
    let quote: [Quote]
}

struct Quote: Decodable {
    let volume: [Int]
    let open: [Decimal]
    let high: [Decimal]
    let low: [Decimal]
    let close: [Decimal]
}

struct StockPrice: Identifiable {
    let timestamp: Date
    let volume: Int
    let open: Decimal
    let high: Decimal
    let low: Decimal
    let close: Decimal
    
    var id: Date { timestamp }
}

extension Stock {
    var prices: [StockPrice] {
        var prices: [StockPrice] = []
        guard let quote = indicators.quote.first else { return prices }
        
        for index in timestamp.indices {
            prices.append(
                StockPrice(
                    timestamp: .init(timeIntervalSince1970: timestamp[index]),
                    volume: quote.volume[index],
                    open: quote.open[index],
                    high: quote.high[index],
                    low: quote.low[index],
                    close: quote.close[index]
                )
            )
        }
        return prices
    }
}

extension StockPrice {
    static let mock: Self = .init(
        timestamp: .now,
        volume: 65079000,
        open: 4.059999942779541,
        high: 4.46999979019165,
        low: 3.5,
        close: 3.5399999618530273
    )
}

extension Stock {
    static var mocks: [Self] {
        var stocks: [Self] = []
        
        let urls = [
            Bundle.main.url(forResource: "mockAAPL", withExtension: "json")!,
            Bundle.main.url(forResource: "mockMSFT", withExtension: "json")!,
            Bundle.main.url(forResource: "mockIBM", withExtension: "json")!,
            Bundle.main.url(forResource: "mockAMD", withExtension: "json")!,
        ]
        
        for url in urls {
            let data = try! Data(contentsOf: url)
            stocks.append(try! JSONDecoder().decode(StockData.self, from: data).chart.stocks[0])
        }
        return stocks
    }
}
