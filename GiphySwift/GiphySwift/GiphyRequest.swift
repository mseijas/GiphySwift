//
//  Request.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

typealias GiphyResponseProperties = (responseType: Any.Type, expectsPagination: Bool)

public struct GiphyRequest { }

// MARK: - GiphyRequset: Gif
extension GiphyRequest {
    public enum Gif: GiphyRequestable {
        
        case withId(_: String)
        case withIds(_: [String])
        case trending
        
        var properties: GiphyResponseProperties {
            return (responseType: [JSON].self, expectsPagination: true)
        }
        
        static private var urlPrefix = "/gifs"
        var urlComponents: String {
            let url = Gif.urlPrefix
            
            switch self {
            case .withId(let id): return url + "/\(id)"
            case .withIds(let ids): return url + "?ids=\(ids.joined(separator: ","))"
            case .trending: return url + "/trending"
            }
        }
        
        
        public enum Search: GiphyRequestable {
            case search(_: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: [JSON].self, expectsPagination: true)
            }
            
            static private var urlPrefix = Gif.urlPrefix
            var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .search(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        public enum Translate: GiphyRequestable {
            case translate(_: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: JSON.self, expectsPagination: false)
            }
            
            static private var urlPrefix = Gif.urlPrefix + "/translate"
            var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .translate(let phrase): return url + "?s=\(phrase)"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case random(tag: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: [JSON].self, expectsPagination: true)
            }
            
            static private var urlPrefix = Gif.urlPrefix + "/random"
            var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .random(let tag): return url + "/tag?q=\(tag)"
                }
            }
        }
        
    }
}


// MARK: - GiphyRequset: Sticker
extension GiphyRequest {
    public enum Sticker: GiphyRequestable {
        
        case trending
        
        var properties: GiphyResponseProperties {
            return (responseType: [JSON].self, expectsPagination: true)
        }
        
        static private var urlPrefix = "/stickers"
        var urlComponents: String {
            let url = Sticker.urlPrefix
            
            switch self {
            case .trending: return url + "/trending"
            }
        }
        
        public enum Search: GiphyRequestable {
            case phrase(_: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: [JSON].self, expectsPagination: true)
            }
            
            static private var urlPrefix = Sticker.urlPrefix
            var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        public enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: JSON.self, expectsPagination: false)
            }
            
            static private var urlPrefix = Sticker.urlPrefix + "/translate"
            var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "?s=\(phrase)"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case tag(_: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: [JSON].self, expectsPagination: true)
            }
            
            static private var urlPrefix = Sticker.urlPrefix + "/random"
            var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .tag(let phrase): return url + "/tag?q=\(phrase)"
                }
            }
        }
        
    }
}


// MARK: - GiphyRequestable
internal protocol GiphyRequestable {
    var urlComponents: String { get }
    var url: URL { get }
    var properties: GiphyResponseProperties { get }
}

extension GiphyRequestable {
    var url: URL {
        var url = Configuration.baseUrl + urlComponents
        if urlComponents.range(of: "?q=") != nil || urlComponents.range(of: "?s=") != nil {
            url += "&api_key=\(Giphy.apiKey)"
        } else {
            url += "?api_key=\(Giphy.apiKey)"
        }
        return URL(string: url)!
    }
}
