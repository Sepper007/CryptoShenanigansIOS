import Foundation

struct MappedBalance: Identifiable {
    var symbol: String
    var amount: Double
    var notionalValue: Double
    var notionalCurrency: String
    var rate: Double
    let id = UUID()
    
    static func fromAPIResponse (_ balance: BalanceItem) -> MappedBalance {
        MappedBalance(
            symbol: balance.symbol,
            amount: MappedBalance.convertStringToDouble(balance.amount),
            notionalValue: MappedBalance.convertStringToDouble(balance.notionalValue),
            notionalCurrency: balance.notionalCurrency,
            rate: MappedBalance.convertStringToDouble(balance.rate)
        )
    }
    
    static private func convertStringToDouble(_ str: String) -> Double {
        Double(str) ?? 0.0
    }
}
