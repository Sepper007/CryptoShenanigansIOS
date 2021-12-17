import Foundation

struct PlatformMetadata: Codable, Identifiable {
    let id = UUID()
    var supportedCoins: [CoinMetadata] = []
}
