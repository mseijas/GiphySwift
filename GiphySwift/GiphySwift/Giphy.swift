//
//  Giphy.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/12/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public typealias GiphyRequestResult = GiphyResult<[GiphyImageResult]>
public typealias GiphyRandomRequestResult = GiphyResult<[GiphyRandomImageResult]>
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
    
    static public func request(_ endpoint: GiphyRequest.Gif.Random, limit: Int = 10, offset: Int = 0, rating: Rating? = nil, completionHandler: @escaping (GiphyRandomRequestResult) -> Void) {
        dataTask(with: endpoint, completionHandler: completionHandler)
    }
    
    static private func dataTask<T>(with endpoint: GiphyRequestable, completionHandler: @escaping (GiphyResult<T>) -> Void) {
        let url = endpoint.url
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if let error = error {
                completionHandler(GiphyResult<T>.error(error))
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
                    completionHandler(GiphyResult<T>.error(error))
                    return
                }
                
                guard status == 200 else {
                    let error = NSError(domain: "com.GiphySwift", code: status, userInfo: ["Reason":msg])
                    completionHandler(GiphyResult<T>.error(error))
                    return
                }
                
                var giphyResults: T
                if endpoint.properties.responseType == [JSON].self {
                    guard let data = json["data"] as? [JSON] else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    guard let imageResults = data.flatMap(GiphyImageResult.init) as? T else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not downcast model to GiphyResult of type \(T.self)"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    giphyResults = imageResults
                }
                else if endpoint.properties.responseType == JSON.self {
                    guard let data = json["data"] as? JSON else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    guard let result = GiphyImageResult(json: data) else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    guard let imageResult = result as? T else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not downcast model to GiphyResult of type \(T.self)"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    giphyResults = imageResult
                }
                else {
                    let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse data property from JSON response"])
                    completionHandler(GiphyResult<T>.error(error))
                    return
                }
                
                
                var giphyResultProperties: GiphyResultProperties? = nil
                if endpoint.properties.expectsPagination == true {
                    guard let pagination = json["pagination"] as? JSON else {
                        let error = NSError(domain: "com.GiphySwift", code: 900, userInfo: ["Reason":"Could not parse pagination property from JSON response"])
                        completionHandler(GiphyResult<T>.error(error))
                        return
                    }
                    
                    giphyResultProperties = GiphyResultProperties(json: pagination)
                }
                
                completionHandler(GiphyResult<T>.success(result: giphyResults, properties: giphyResultProperties))
            }
            
        }.resume()
    }
    
}
