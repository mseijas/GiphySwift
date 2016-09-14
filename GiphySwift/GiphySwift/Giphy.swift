//
//  Giphy.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/12/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(result: T)
    case error(_: Error)
}

typealias GiphyRequestResult = Result<[GiphyResult]>


struct Giphy {
    
    enum Rating: String {
        case y, g, pg, pg13, r
    }
    
    enum ApiKey {
        case `public`, `private`(key: String)
        
        var key: String {
            switch self {
            case .public: return Configuration.publicApiKey
            case .private(let key): return key
            }
        }
    }
    
    private(set) static var apiKey = ApiKey.public.key
    
    func configure(with apiKey: ApiKey) {
        Giphy.apiKey = apiKey.key
    }
    
    static func request(_ endpoint: GiphyRequest.Gif, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: (GiphyRequestResult) -> Void) {
        let url = endpoint.url
        let urlRequest = URLRequest(url: url)
        
        dataTask(with: urlRequest) { (result) in
            switch result {
            case .success(let giphyResults): print(giphyResults)
            case .error(let error): print("Error: \(error)")
            }
        }
    }
    
    static private func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            // print("data: \(data)")
            // print("response: \(response)")
            // print("error: \(error)")

            
            if let data = data, error == nil {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])

                let giphyResults = GiphyResult(json: json)
                completionHandler(GiphyRequestResult.success(result: [giphyResults]))
            }
            
            if let error = error {
                completionHandler(GiphyRequestResult.error(error))
            }
            
        }.resume()
    }
    
}
