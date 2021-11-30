import SwiftUI

struct BalanceItemView: View {
    
    var balance: MappedBalance
    var currency: String
    var ratio: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
            Text(balance.symbol)
                .font(.headline)
            Spacer()
                Text("~\(Mapper.formatDoubleToString(balance.notionalValue / ratio)) \(self.currency)")
            }
            Spacer()
            HStack {
                Text("Amt: \(Mapper.formatDoubleToString(balance.amount))")
                Spacer()
                Text("\(Mapper.formatDoubleToString(balance.rate / self.ratio)) \(balance.symbol)/\(self.currency)")
            }
        }.padding(3)
    }
}

struct BalanceItem_Previews: PreviewProvider {
    
    static let data: MappedBalance = MappedBalance(symbol: "BTC", amount: 451249759898211, notionalValue:7500, notionalCurrency: "USD", rate: 0.0000654321)
    
    static var previews: some View {
        BalanceItemView(balance: data, currency: "USD", ratio: 1.0)
    }
}
