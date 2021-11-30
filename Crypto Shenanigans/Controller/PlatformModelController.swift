import Foundation

@MainActor
class PlatformModelController: ObservableObject {
    @Published var isLoading = false
    @Published var data: [Platform] = []
    
    private var apiHelper = API()
    
    func load() async {
        isLoading = true
        do {
            let responseData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath:"/platform", httpMethod: .get)
            
            self.data = try API.jsonDecoder.decode([Platform].self, from:responseData)
            
            self.isLoading = false
        } catch CustomError.HttpResponseError(let message) {
            self.isLoading = false
            print("Platform call failed with error message \(message)")
        } catch {
            self.isLoading = false
            print(error)
        }
    }
}
