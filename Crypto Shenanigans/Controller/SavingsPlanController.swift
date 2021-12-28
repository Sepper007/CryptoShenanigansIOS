import Combine

@MainActor
class SavingsPlanController: ObservableObject {
    @Published var loading = false
    @Published var items: [SavingsPlan] = []
    
    private var apiHelper = API()
    
    func load() async {
        do {
            self.loading = true
            
            let respData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/savings-plans", httpMethod: .get, accept: .application_json)
            
            self.items = try API.jsonDecoder.decode([SavingsPlan].self, from: respData)
            
            self.loading = false
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Savings Plan call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
    }
    
    func removeItem (savingsPlanId: Int) async {
        do {
            try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/savings-plans/\(savingsPlanId)", httpMethod: .delete)
        
            guard let index = items.firstIndex(where: { $0.id == savingsPlanId }) else { return }
            self.items.remove(at: index)
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Deleting Savings Plan call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
    }
    
    func editItem (savingsPlanId: Int, updatedPlan: UpdateSavingsPlanPayload) async {
        do {
            try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/savings-plans/\(savingsPlanId)", httpMethod: .put, payload:  API.jsonEncoder.encode(updatedPlan), contentType: .application_json)
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Updating Savings Plan call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
    }
    
    func addItem (_ newPlan: SavingsPlan) async {
        do {
            let decodedData = try API.jsonEncoder.encode(newPlan)
            
            let responseData = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/savings-plans", httpMethod: .post, payload: decodedData, contentType: .application_json)
            
            let newPlanId = (try API.jsonDecoder.decode(CreateSavingsPlanResponse.self, from: responseData)).id
            
            let mergedPlanObj = SavingsPlan(tradingPair: newPlan.tradingPair, amount: newPlan.amount, currency: newPlan.currency, platformName: newPlan.platformName, platformDescription: newPlan.platformDescription, frequencyUnit: newPlan.frequencyUnit, frequencyValue: newPlan.frequencyValue, id: newPlanId)
            
            self.items.append(mergedPlanObj)
        } catch CustomError.HttpResponseError(let message) {
            loading = false
            print("Deleting Savings Plan call failed with error message \(message)")
        } catch {
            loading = false
            print("Custom error")
            print(error)
        }
    }
}
