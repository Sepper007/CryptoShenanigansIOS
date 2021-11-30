import Foundation

struct BalanceResponse: Codable {
    var total: BalanceTotal
    var holdings: [BalanceItem]
    var defaultCurrency: String
}
