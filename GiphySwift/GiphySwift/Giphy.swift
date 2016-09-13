//
//  Giphy.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/12/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

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
        print("SOMETHING SOMETHING")
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
    
    static func request(_ endpoint: Endpoint, block: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        print("SOMETHING SOMETHING")
        let urlRequest = URLRequest(url: endpoint.url)
        print("urlRequest: \(urlRequest)")
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            print("data: \(data)")
//            print("response: \(response)")
//            print("error: \(error)")
//            
//            if let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                
//                print(json)
//                
//            }
//            }.resume()
        URLSession.shared.dataTask(with: urlRequest, completionHandler: block)
    }
}
