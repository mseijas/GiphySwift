//: Playground - noun: a place where people can play

import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct Giphy {
    
    static let host = "api.giphy.com"
    static let apiVersion = "v1"
    static let baseUrl = "https://\(host)/\(apiVersion)"
    
    enum Endpoint {
        case search(phrase: String)
        case gif(id: String)
        case gifs(ids: [String])
        case translate(phrase: String)
        
        var url: URL {
            var url = Giphy.baseUrl
            
            switch self {
            case .search(let phrase): url += "/gifs/search?q=\(phrase)"
            default: break
            }
            
            url += "&api_key=\(Giphy.apiKey)"
            
            return URL(string: url)!
        }
    }
    
    enum Rating {
        case y, g, pg, pg13, r
    }
    
    private(set) static var apiKey = "dc6zaTOxFJmzC"
    
    func configure(apiKey: String) {
        Giphy.apiKey = apiKey
    }
    
    static func request(_ endpoint: Endpoint) {
        let urlRequest = URLRequest(url: endpoint.url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            print("data: \(data)")
            print("response: \(response)")
            print("error: \(error)")
            
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                
                print(json)
                
            }
            }.resume()
    }
    
}

//Giphy.request(.search(phrase: "britney"))

