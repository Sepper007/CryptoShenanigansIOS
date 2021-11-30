struct Platform: Codable, Identifiable {
    var active: Bool
    var description: String
    var id: String
    var platformUserId: Int
    var userCredentialsAvailable: Bool
}
