import SwiftUI

struct HomeView: View {
    
    let logoutSuccesful: () -> Void
    
    @State private var loading = false
    
    @StateObject private var platformModelController: PlatformModelController = PlatformModelController()
    
    // There seems to be a bug in the current SwiftUI version (https://stackoverflow.com/questions/63080830/swifui-onappear-gets-called-twice),
    // TODO: Remove this workaround once the bug is fixed by the framework.
    @State private var firstAppear = true
     
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
                NavigationLink(destination: PlatformListView(name: Module.analytics.title)
                                .environmentObject(platformModelController)) {
                    ModuleView(module: Module.analytics)
                }
                NavigationLink(destination: BotTradingListView()
                                .environmentObject(platformModelController)) {
                    ModuleView(module: Module.botTrading)
                }
                NavigationLink(destination: SavingsPlanListView()
                                .environmentObject(platformModelController)) {
                    ModuleView(module: Module.savingsPlan)
                }
            }
            .onAppear(perform: {
                if(firstAppear) {
                    firstAppear = false
                    Task.init {
                        await platformModelController.load()
                    }
                }
            })
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
