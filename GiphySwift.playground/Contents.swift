//: Playground - noun: a place where people can play

import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public struct Giphy {
    
    static let host = "api.giphy.com"
    static let apiVersion = "v1"
    static let baseUrl = "https://\(host)/\(apiVersion)"
    static let publicApiKey = "dc6zaTOxFJmzC"
    
    
    
    enum Rating {
        case y, g, pg, pg13, r
    }
    
    enum ApiKey {
        case `public`, `private`(key: String)
        
        var key: String {
            switch self {
            case .public: return publicApiKey
            case .private(let key): return key
            }
        }
    }
    
    private(set) static var apiKey = ApiKey.public.key
    
    func configure(with apiKey: ApiKey) {
        Giphy.apiKey = apiKey.key
    }
    
    static func request(_ request: Request.Gif) {
        print(request)
    }
}



//protocol GiphyEndpoint {
//    func request()
//}
//
//extension GiphyEndpoint {
//    func request() {
//        Giphy.request(self)
//    }
//}

//protocol GifRequestable: GiphyEndpoint {
//    //var type: GifRequest.Type { get }
//    var limit: Int { get }
//    var offset: Int { get }
//    var rating: Giphy.Rating? { get }
//}

//
//struct EndpointOptions {
//    
//    struct Gifs {
//        let limit: Int
//        let offset: Int
//        let rating: Giphy.Rating?
//        
//        init(limit: Int = 25, offset: Int = 0, rating: Giphy.Rating? = nil) {
//            self.limit = limit
//            self.offset = offset
//            self.rating = rating
//        }
//    }
//    
//    struct Stickers {
//        
//    }
//    
//}

// MARK: - GiphyRequestable
fileprivate protocol GiphyRequestable {
    var urlComponents: String { get }
    var url: URL { get }
}

extension GiphyRequestable {
    var url: URL {
        let url = Giphy.baseUrl + urlComponents + "&api_key=\(Giphy.apiKey)"
        return URL(string: url)!
    }
}


// MARK: - GiphyRequest
struct GiphyRequest { }

extension GiphyRequest {
    enum Gif {
        
        case withId(_: String)
        case withIds(_: [String])
        case trending
        
        static private var urlPrefix = "/gifs"
        fileprivate var urlComponents: String {
            let url = Gif.urlPrefix
            
            switch self {
            case .withId(let id): return url + "/\(id)"
            case .withIds(let ids): return url + "?ids=\(ids.joined(separator: ","))"
            case .trending: return url + "/trending"
            }
        }
        
        enum Search: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Gif.urlPrefix
            fileprivate var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Gif.urlPrefix + "/translate"
            fileprivate var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/s?q=\(phrase)"
                }
            }
        }
        
        enum Random: GiphyRequestable {
            case tag(_: String)
            
            static private var urlPrefix = Gif.urlPrefix + "/random"
            fileprivate var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .tag(let phrase): return url + "/tag?q=\(phrase)"
                }
            }
        }
        
    }
}


extension GiphyRequest {
    enum Sticker {
        
        case trending
        
        static private var urlPrefix = "/stickers"
        fileprivate var urlComponents: String {
            let url = Sticker.urlPrefix
            
            switch self {
            case .trending: return url + "/trending"
            }
        }
        
        enum Search: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix
            fileprivate var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/translate"
            fileprivate var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/s?q=\(phrase)"
                }
            }
        }
        
        enum Random: GiphyRequestable {
            case tag(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/random"
            fileprivate var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .tag(let phrase): return url + "/tag?q=\(phrase)"
                }
            }
        }
        
    }
}
