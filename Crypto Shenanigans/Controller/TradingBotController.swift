import Foundation
import SwiftUI

@MainActor
class TradingBotController: ObservableObject {
    
    let apiHelper = API()
    
    @Published var loading = false
    @Published var data : BotTradingResponse? = nil
    
    func getListOfBots() async {
        do {
            loading = true
            
            let respData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/bots", httpMethod: .get, accept: .application_json)
            
            self.data = try API.jsonDecoder.decode(BotTradingResponse.self, from: respData)
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Savings Plan call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
        
        
    }
}
