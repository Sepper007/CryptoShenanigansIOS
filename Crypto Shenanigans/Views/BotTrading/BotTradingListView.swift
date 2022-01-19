import SwiftUI

struct BotTradingListView: View {
    
    // There seems to be a bug in the current SwiftUI version (https://stackoverflow.com/questions/63080830/swifui-onappear-gets-called-twice),
    // TODO: Remove this workaround once the bug is fixed by the framework.
    @State private var firstAppear = true
    
    @StateObject var tradingBotController = TradingBotController()
    
    var body: some View {
        List {
            Section("Active Bots") {
                ForEach(tradingBotController.data?.active ?? [], id: \.uuid) { botConfig in
                    VStack {
                        TradingBotItemView(data: botConfig)
                    }
                }
            }
            Section("Inactive Bots") {
                ForEach(tradingBotController.data?.inactive ?? [], id: \.uuid) { botConfig in
                    VStack {
                        TradingBotItemView(data: botConfig)
                    }
                }
            }
        }.onAppear(perform: {
        if(firstAppear) {
            firstAppear = false
            Task.init {
                await tradingBotController.getListOfBots()
            }
            }
        })
    }
}
