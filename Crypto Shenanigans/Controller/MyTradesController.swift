import Foundation

@MainActor
class MyTradesController: ObservableObject {
    @Published var loading = false
    @Published var items: [MyTradesResponse] = []
    
    private var apiHelper = API()
    
    func load(platformId: String) async {
        do {
            loading = true
            
            let respData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/\(platformId)/my-trades", httpMethod: .get, accept: .application_json)
            
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .iso8601
            
            print(respData)
            
            self.items = try decoder.decode([MyTradesResponse].self, from: respData)
        
            loading = false
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Logout call failed with error message \(message)")
        } catch {
            loading = false
            print(error)
        }
    }
}
