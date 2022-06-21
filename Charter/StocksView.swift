import SwiftUI

struct StocksView: View {
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 60)
            PriceChart()
            Spacer()
            QuotesChart()
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StocksView()
    }
}
