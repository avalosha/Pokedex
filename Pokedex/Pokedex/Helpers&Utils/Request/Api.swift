//
//  Api.swift
//  Pokedex
//
//  Created by Álvaro Ávalos Hernández on 13/04/22.
//

import Foundation

class Api {
    
    static let session: URLSession = URLSession.shared
    static let timeout: TimeInterval = 30
    static var pendingRequest = [(URLRequest, (Data?,CodeResponse) -> ())]()
    
    enum EndPoints {
        case pokemonApi
        
        var endPoint: String {
            switch self {
            case .pokemonApi:
                return "api/v2/pokemon?"
            }
        }
    }
    
    enum Method: String {
        case GET
        case POST
        case DELETE
    }
    
    enum ContentType: String {
        case json = ""
    }
    
    static func makeURLRequest(endpoint: EndPoints, method: Method = .GET, parameters: [String:Any]? = nil, contentType: ContentType = .json) -> URLRequest {
        let url = getURL(endpoint: endpoint)
        return makeURLRequest(url: url, method: method, parameters: parameters, contentType: contentType)
    }
    
    static func makeURLRequest(url: URL, method: Method = .GET, parameters: [String:Any]? = nil, contentType: ContentType = .json) -> URLRequest {
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let content = contentType.rawValue
        urlRequest.setValue(content, forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = timeout
        if let params = parameters {
            if method == .GET {
                let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
                let newURL = URL(string: "\(url.absoluteString)?\(jsonString)")
                urlRequest.url = newURL
            }
        }
        
        return urlRequest
    }
    
    static func getURL(endpoint: EndPoints) -> URL {
        URL(string: "\(ApiConstants.baseURL)\(endpoint.endPoint)")!
    }
    
    static func request(url: URLRequest, retry: Int = 3, completion: @escaping (Data?,CodeResponse) -> ()) {
        pendingRequest.append((url,completion))
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let httpURLResponse = response as? HTTPURLResponse, let code = CodeResponse(rawValue: httpURLResponse.statusCode) else {
                    completion(nil, .timeout)
                    print("API: ",error?.localizedDescription ?? "")
                    return
                }
                
                completion(data, code)
                return
            }
        }.resume()
    }
}

enum CodeResponse: Int {
    case success = 200
    case bad_request = 400
    case error_server = 500
    case timeout = -1002
    case not_conection = -1001
    
    var message: String {
        switch self {
        case .success:
            return "Exitoso"
        case .bad_request, .error_server:
            return "Servicio no disponible"
        default:
            return "Error interno"
        }
    }
}
