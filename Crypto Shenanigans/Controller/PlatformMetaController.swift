import Foundation

@MainActor
class PlatformMetaController: ObservableObject {
    var api = API()
    
    @Published var loading = false
    @Published var data: PlatformMetadata? = nil
    
    func load(platformId: String) async {
        do {
            loading = true
            
            let respData = try await api.makeRequest(baseUrl: .nodeBackend, urlPath: "/\(platformId)/meta", httpMethod: .get, accept: .application_json)
    
            loading = false
            
            self.data = try API.jsonDecoder.decode(PlatformMetadata.self, from: respData)
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
