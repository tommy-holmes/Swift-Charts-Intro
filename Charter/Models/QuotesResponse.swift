import Foundation

struct QuotesResponse: Decodable {
    let quotes: Quotes
    
    enum CodingKeys: String, CodingKey {
        case quotes = "quoteResponse"
    }
}

struct Quotes: Decodable {
    let stocks: [StockQuote]
    
    enum CodingKeys: String, CodingKey {
        case stocks = "result"
    }
}

struct StockQuote: Decodable {
    let currency: String
    let trailingPE: Double
    let forwardPE: Double
    let bid: Double
    let ask: Double
    let shortName: String
    let symbol: String
    
    init(currency: String, trailingPE: Double, forwardPE: Double, bid: Double, ask: Double, shortName: String, symbol: String) {
        self.currency = currency
        self.trailingPE = trailingPE
        self.forwardPE = forwardPE
        self.bid = bid
        self.ask = ask
        self.shortName = shortName
        self.symbol = symbol
    }
}

extension StockQuote: Identifiable {
    var id: String { symbol }
}

extension StockQuote: Comparable {
    static func < (lhs: StockQuote, rhs: StockQuote) -> Bool {
        lhs.ask < rhs.ask
    }
}

extension Quotes {
    static let mock: Self = .init(stocks: [
        StockQuote(currency: "USD", trailingPE: 38.2364, forwardPE: 20.380001, bid: 102.9, ask: 101.93, shortName: "Advanced Micro Devices, Inc.", symbol: "AMD"),
        StockQuote(currency: "USD", trailingPE: 23.128592, forwardPE: 13.502397, bid: 141, ask: 142.63, shortName: "International Business Machines", symbol: "IBM"),
        StockQuote(currency: "USD", trailingPE: 24.1095, forwardPE: 22.55488, bid: 148.35, ask: 148.58, shortName: "Apple, Inc.", symbol: "AAPL"),
    ])
}
