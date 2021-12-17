import Foundation

struct CoinMetadata: Identifiable, Codable {
    var id: String
    var marketId: String
    var metaId: String
    var minimumQuantity: Double
}
