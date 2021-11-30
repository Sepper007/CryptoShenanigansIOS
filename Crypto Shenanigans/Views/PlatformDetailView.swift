import SwiftUI

struct PlatformDetailView: View {
    
    var platform: Platform
    
    // There seems to be a bug in the current SwiftUI version (https://stackoverflow.com/questions/63080830/swifui-onappear-gets-called-twice),
    // TODO: Remove this workaround once the bug is fixed by the framework.
    @State private var firstAppear = true
    
    @StateObject private var balanceController = BalanceController()
    
    @StateObject private var myTradesController = MyTradesController()
    
    var allCurrencies: [String] {
        var items = balanceController.items.map { $0.symbol }
        
        items.insert(balanceController.total.currency, at: 0)
        
        return items
    }
    
    var currentRatio: Double {
        balanceController.items.first(where: { $0.symbol == balanceController.currency })?.rate ?? 1.0
    }
    
    
    var body: some View {
        List {
            Section(header: HStack(alignment: .center) {
                    Text("Holdings")
                    Spacer()
                    Text("Currency:")
                    Picker(selection: $balanceController.currency, label: Text("")) {
                        ForEach(allCurrencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    }
                ){
                VStack(alignment: .leading) {
                    HStack {
                        Text("Total")
                        .font(.headline)
                        Spacer()
                        Text("\(Mapper.formatDoubleToString(balanceController.total.value / self.currentRatio)) \(balanceController.currency)")
                    }
                }.padding(3)
                
                ForEach(balanceController.items) { balance in
                    BalanceItemView(balance: balance, currency: balanceController.currency, ratio: self.currentRatio)
                }
            }
            Section(header: Text("Recent Trades")) {
                ForEach(myTradesController.items) { trade in
                    TradeItem(data: trade)
                }
            }
        }.navigationTitle(platform.description)
    
        .onAppear(perform: {
            if(firstAppear) {
                firstAppear = false
                Task.init {
                    await balanceController.load(platformId: platform.id)
                    await myTradesController.load(platformId: platform.id)
                }
            }
        })
        .if(balanceController.loading) { view in
            view.overlay(ProgressView())
        }
    }
}
