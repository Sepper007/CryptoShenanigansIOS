import SwiftUI

struct TradingBotItemView: View {
    var data: BotTradingItem
    
    var body: some View {
        VStack {
            HStack {
                Text(data.additionalInfo.coinId ?? "").bold()
                Spacer()
                Text(data.botType).bold()
            }
            Spacer()
            HStack {
                Text(data.platformName)
                Spacer()
                Text(data.createdAt)
            }
        }.padding()
    }
}

struct TradingBotItemView_Previews: PreviewProvider {
    
    static var mockData = BotTradingItem(uuid: "1234", botType: "grid", platformName: "binance", active: true, createdAt: "2022/1/18 21:23", additionalInfo: AdditionalInformation(coinId: "DOGE/USDT", strategy: "neutral", numberOfGrids: 6, maximumInvestment: 1500, percentagePerGrid: 2))
    
    static var previews: some View {
        TradingBotItemView(data: mockData)
        
    }
    
}
