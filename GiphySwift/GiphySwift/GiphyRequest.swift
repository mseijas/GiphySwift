//
//  Request.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public struct GiphyRequest { }

// MARK: - GiphyRequset: Gif
extension GiphyRequest {
    public enum Gif: GiphyRequestable {
        
        case withId(_: String)
        case withIds(_: [String])
        case trending
        
        static private var urlPrefix = "/gifs"
        var urlComponents: String {
            let url = Gif.urlPrefix
            
            switch self {
            case .withId(let id): return url + "?ids=\(id)"
            case .withIds(let ids): return url + "?ids=\(ids.joined(separator: ","))"
            case .trending: return url + "/trending"
            }
        }
        
        
        public enum Search: GiphyRequestable {
            case search(_: String)
            
            static private var urlPrefix = Gif.urlPrefix
            var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .search(let phrase): return url + "/search?q=\(phrase.replacingOccurrences(of: " ", with: "+"))"
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
                case .translate(let phrase): return url + "?s=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case random(tag: String)
            
            var properties: GiphyResponseProperties {
                return (responseType: JSON.self, expectsPagination: false)
            }
            
            static private var urlPrefix = Gif.urlPrefix
            var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .random(let tag): return url + "/random?tag=\(tag.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
    }
}


// MARK: - GiphyRequset: Sticker
extension GiphyRequest {
    public enum Sticker: GiphyRequestable {
        
        case trending
        
        static private var urlPrefix = "/stickers"
        var urlComponents: String {
            let url = Sticker.urlPrefix
            
            switch self {
            case .trending: return url + "/trending"
            }
        }
        
        public enum Search: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix
            var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/translate"
            var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "?s=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case tag(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/random"
            var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .tag(let phrase): return url + "/tag?q=\(phrase.replacingOccurrences(of: " ", with: "+"))"
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
    var properties: GiphyResponseProperties {
        return (responseType: [JSON].self, expectsPagination: true)
    }
    
    var url: URL {
        var url = Configuration.baseUrl + urlComponents
        if urlComponents.range(of: "?q=") != nil || urlComponents.range(of: "?s=") != nil || urlComponents.range(of: "?ids=") != nil || urlComponents.range(of: "?tag=") != nil {
            url += "&api_key=\(Giphy.apiKey)"
        } else {
            url += "?api_key=\(Giphy.apiKey)"
        }
        return URL(string: url)!
    }
}
