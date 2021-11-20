import SwiftUI
import Foundation

struct LoginPayload: Codable {
    var email: String
    var password: String
}

struct LoginView: View {
    
    var loginSuccessful: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    
    private let apiHelper = API()
    
    @State private var loading = false

    func login (username: String, password: String) async {
        let payload = LoginPayload(email: username, password: password)
        
        do {
            let jsonData = try API.jsonEncoder.encode(payload)
        
            loading = true
            
            try await apiHelper.makeRequest(baseUrl: .nodeBackend, urlPath:"/login", httpMethod: .post, payload: jsonData, contentType: .application_json)
            
            loading = false
            
            loginSuccessful()
        } catch CustomError.HttpResponseError(let errorMessage) {
            print("Http call failed with message \(errorMessage)")
            loading = false
            return
        } catch {
            loading = false
            print("An error occurred while processing the API request: \(error)")
            return
        }
    }

    
    var body: some View {
        VStack() {
                    Text("Login")
                        .font(.largeTitle).foregroundColor(Color.white)
                        .padding([.top, .bottom], 40)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    Image("iosapptemplate")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .padding(.bottom, 50)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                        
                        SecureField("Password", text: self.$password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }.padding([.leading, .trailing], 27.5)
                    
                    Button(action: {
                        Task.init {
                            await self.login(username: self.$email.wrappedValue, password: self.$password.wrappedValue)
                        }
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }.padding(.top, 50)
                    
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Don't have an account? ")
                        Button(action: {}) {
                            Text("Sign Up")
                                .foregroundColor(.black)
                        }
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
                .if($loading.wrappedValue) { view in
                    view.overlay(ProgressView())
                }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccessful: {
            print("I was here, login callback")
        })
    }
}
    
