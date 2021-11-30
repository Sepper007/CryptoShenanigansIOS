import Foundation

let defaultSession = URLSession(configuration: .default)
let jsonEncoder = JSONEncoder()

enum CustomError: Error {
    case HttpResponseError(String)
    case RuntimeError
}

class API {
    
    enum BaseUrl: String {
        case nodeBackend = "http://localhost:3000/api"
        // case nodeBackend = "https://sepp-coin-tracker.herokuapp.com/api"
    }
    
    enum HttpMethod: String {
        case get, put, post, delete, patch
    }
    
    enum ContentType: String {
        case application_json = "application/json"
    }
    
    struct HttpHeader {
        let name: String
        let value: String
    }
    
    private var session: URLSession
    
    init (session: URLSession = defaultSession) {
        self.session = session
    }
    
    public static let jsonEncoder = JSONEncoder()
    public static let jsonDecoder = JSONDecoder()
    
    static func encodeJSONPayload(_ data: [String:Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: data)
    }
    
    func makeRequest (baseUrl: BaseUrl, urlPath: String = "", httpMethod: HttpMethod = .get, payload: Data? = nil,
                      httpHeaders: [HttpHeader] = [], contentType: ContentType = .application_json, accept: ContentType = .application_json) async throws -> Data {
        let fullUrl = baseUrl.rawValue + urlPath
        
        print("Full url " + fullUrl)
        print("Http method " + httpMethod.rawValue)
        
        guard let url = URL(string: fullUrl) else {
            print("Could not instantiate url")
            throw CustomError.RuntimeError
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.setValue(accept.rawValue, forHTTPHeaderField: "Accept")
        
        if (payload != nil) {
            request.httpBody = payload
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        for httpHeader in httpHeaders {
            request.setValue(httpHeader.value, forHTTPHeaderField: httpHeader.name)
        }
        
        let (data, response) = try await self.session.data(for: request)
        
        let httpResponse = response as! HTTPURLResponse
        
        if (httpResponse.statusCode >= 400) {
            throw CustomError.HttpResponseError("The HTTP request failed with status code \(httpResponse.statusCode) and response \(String(decoding: data, as: UTF8.self))")
            // Find out why this isn't done automatically by the URLSession object and change behaviour if possbile
        }
            
        return data
    }
}
