import Foundation

struct BalanceItem: Codable {
    var symbol: String
    var amount: String
    var notionalValue: String
    var notionalCurrency: String
    var rate: String
}
