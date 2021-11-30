import Combine

@MainActor
class BalanceController: ObservableObject {
    @Published var loading = false
    @Published var total: BalanceTotal = BalanceTotal(value: 0.0, currency: "USD")
    @Published var currency: String = "USD"
    @Published var items: [MappedBalance] = []
    
    private var apiHelper = API()
    
    func load(platformId: String) async {
        do {
            loading = true
            
            let responseData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath:"/\(platformId)/balance", httpMethod: .get)
            
            let mappedData = (try API.jsonDecoder.decode(BalanceResponse.self, from: responseData))
                
            total = mappedData.total
            
            currency = mappedData.defaultCurrency
            
            items = mappedData.holdings.map({MappedBalance.fromAPIResponse($0)})
            
            loading = false
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Logout call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
    }
}
