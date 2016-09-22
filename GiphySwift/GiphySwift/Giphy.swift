//
//  Giphy.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/12/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public typealias GiphyRequestResult = GiphyResult<[GiphyImageResult]>
public typealias KByte = Int
typealias JSON = [String:AnyObject]

public enum GiphyResult<T> {
    case success(result: T, properties: GiphyResultProperties?)
    case error(_: Error)
}


public struct Giphy {
    
    public enum Rating: String {
        case y, g, pg, pg13, r
    }
    
    public enum ApiKey {
        case `public`, `private`(key: String)
        
        var key: String {
            switch self {
            case .public: return Configuration.publicApiKey
            case .private(let key): return key
            }
        }
    }
    
    
    
    static private let _dateFormatter = DateFormatter()
    internal static var dateFormatter: DateFormatter {
        Giphy._dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return Giphy._dateFormatter
    }
    
    private(set) static var apiKey = ApiKey.public.key
    
    public static func configure(with apiKey: ApiKey) {
        Giphy.apiKey = apiKey.key
    }
    
    static public func request(_ endpoint: GiphyRequest.Gif, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        dataTask(with: endpoint, completionHandler: completionHandler)
    }
    
    static public func request(_ endpoint: GiphyRequest.Gif.Search, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        dataTask(with: endpoint, completionHandler: completionHandler)
    }
    
    static public func request(_ endpoint: GiphyRequest.Gif.Translate, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        dataTask(with: endpoint, completionHandler: completionHandler)
    }
    
    static private func request(_ endpoint: GiphyRequestable, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        dataTask(with: endpoint, completionHandler: completionHandler)
    }
    
    static private func dataTask(with endpoint: GiphyRequestable, completionHandler: @escaping (GiphyRequestResult) -> Void) {
        let url = endpoint.url
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            // print("data: \(data)")
            // print("response: \(response)")
            // print("error: \(error)")
            
            if let error = error {
                completionHandler(GiphyRequestResult.error(error))
            }
            
            if let data = data,
                error == nil,
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON,
                let json = jsonDict {
                
                guard let responseMeta = json["meta"] as? JSON,
                    let status = responseMeta["status"] as? Int,
                    let msg = responseMeta["msg"] as? String
                else {
                    let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse JSON response"])
                    completionHandler(GiphyRequestResult.error(error))
                    return
                }
                
                guard status == 200 else {
                    let error = NSError(domain: "com.GiphySwift", code: status, userInfo: ["Reason":msg])
                    completionHandler(GiphyRequestResult.error(error))
                    return
                }
                
                var giphyResults = [GiphyImageResult]()
                if endpoint.properties.responseType == [JSON].self {
                    guard let data = json["data"] as? [JSON] else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyRequestResult.error(error))
                        return
                    }
                    
                    giphyResults = data.flatMap(GiphyImageResult.init)
                }
                else if endpoint.properties.responseType == JSON.self {
                    guard let data = json["data"] as? JSON else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyRequestResult.error(error))
                        return
                    }
                    
                    guard let result = GiphyImageResult(json: data) else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyRequestResult.error(error))
                        return
                    }
                    
                    giphyResults = [result]
                }
                else {
                    let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                    completionHandler(GiphyRequestResult.error(error))
                    return
                }
                
                
                var giphyResultProperties: GiphyResultProperties? = nil
                if endpoint.properties.expectsPagination == true {
                    guard let pagination = json["pagination"] as? JSON else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse pagination property from JSON response"])
                        completionHandler(GiphyRequestResult.error(error))
                        return
                    }
                    
                    giphyResultProperties = GiphyResultProperties(json: pagination)
                }
                
                completionHandler(GiphyRequestResult.success(result: giphyResults, properties: giphyResultProperties))
            }
            
        }.resume()
    }
    
}
