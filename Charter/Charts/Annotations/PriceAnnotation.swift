import SwiftUI

struct PriceAnnotation: View {
    private var price: StockPrice
    
    init(for price: StockPrice) {
        self.price = price
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(price.timestamp.formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.secondary)
            
            HStack {
                Text("O:").foregroundColor(.secondary)
                Text(price.open.formatted(.currency(code: "USD")))
                
                Text("C:").foregroundColor(.secondary)
                Text(price.close.formatted(.currency(code: "USD")))
            }
            
            HStack {
                Text("H:").foregroundColor(.secondary)
                Text(price.high.formatted(.currency(code: "USD")))
                
                Text("L:").foregroundColor(.secondary)
                Text(price.low.formatted(.currency(code: "USD")))
            }
        }
        .lineLimit(1)
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 13)
                .foregroundStyle(.thickMaterial)
        )
    }
}

struct PriceAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        PriceAnnotation(for: StockPrice(timestamp: .now, volume: 3948293, open: 123.567343, high: 150.3234, low: 100.3422, close: 140.5623))
            .previewLayout(.sizeThatFits)
    }
}
