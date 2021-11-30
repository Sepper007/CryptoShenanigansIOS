import Foundation

struct MyTradesResponse: Codable, Identifiable {
    let id = UUID()
    var symbol: String
    var side: String
    var type: String
    var volume: Double
    var price: Double
    var value: Double
    var datetime: String
}
