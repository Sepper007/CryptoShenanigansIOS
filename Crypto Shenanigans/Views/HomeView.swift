import SwiftUI

struct HomeView: View {
    
    let logoutSuccesful: () -> Void
    
    @State private var loading = false
    
    private let apiHelper = API()
    
    func logout() async {
        do {
            try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/logout", httpMethod: .post)
            
            logoutSuccesful()
        } catch CustomError.HttpResponseError(let message) {
            print("Logout call failed with error message \(message)")
        } catch {
            print("error")
        }
    }
        
    var body: some View {
            List {
                ForEach(Module.data) { module in
                    NavigationLink(destination: Text(module.title)) {
                        ModuleView(module: module)
                    }
                }
            }
            .if(loading) { view in
                view.overlay(ProgressView())
            }
            .navigationTitle("Overview")
            .navigationBarItems(trailing: Button(action: {
                Task.init {
                    await logout()
                }
            }) {
                Text("Log Out")
            })
    }
}
