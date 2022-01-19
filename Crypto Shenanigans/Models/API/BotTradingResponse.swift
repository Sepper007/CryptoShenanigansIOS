import Foundation

struct BotTradingResponse: Codable {
    var active: [BotTradingItem]
    var inactive: [BotTradingItem]
}

struct BotTradingItem: Codable {
    var uuid: String
    var botType: String
    var platformName: String
    var active: Bool
    var createdAt: String
    var additionalInfo: AdditionalInformation
}

struct AdditionalInformation : Codable {
    let coinId : String?
    let strategy : String?
    let numberOfGrids : Int?
    let maximumInvestment : Double?
    let percentagePerGrid : Double?
}
