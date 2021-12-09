struct SavingsPlan: Codable, Identifiable {
    var tradingPair: String
    var amount: Double
    var currency: String
    var platformName: String
    var platformDescription: String
    var frequencyUnit: String
    var frequencyValue: Int
    var id: Int
}
