//
//  Crypto_ShenanigansApp.swift
//  Crypto Shenanigans
//
//  Created by Oberhauser, Sebastian on 15.11.21.
//

import SwiftUI

@main
struct Crypto_ShenanigansApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let apiHelper = API()
    private let jsonDecoder = JSONDecoder()
    
    @State private var isAuthenticated = false
    
    func login() {
        isAuthenticated = true
    }
    
    func logout () {
        isAuthenticated = false
    }
    
    
    func phaseChangeHandler (_ phase: ScenePhase) -> Void {
        if(phase == .active) {
            // Ping the backend whenever app became active to check if current session is still active
            Task.init {
                do {
                    let data = try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath: "/logged-in", httpMethod: .get)
                    
                    let responseData = try jsonDecoder.decode(LoggedInResponse.self, from: data)
                
                    isAuthenticated = responseData.authenticated
                } catch {
                    print("An error ocurred while trying to fetch whether the user is currently logged in")
                    isAuthenticated = false
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if (!$isAuthenticated.wrappedValue) {
                LoginView(loginSuccessful: login)
            } else {
                NavigationView {
                    HomeView(logoutSuccesful: logout)
                }
            }
        }.onChange(of: scenePhase, perform: phaseChangeHandler)
    }
}


extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

