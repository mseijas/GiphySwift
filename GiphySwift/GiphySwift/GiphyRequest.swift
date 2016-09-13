//
//  Request.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation


struct GiphyRequest { }

// MARK: - GiphyRequset: Gif
extension GiphyRequest {
    enum Gif: GiphyRequestable {
        
        case withId(_: String)
        case withIds(_: [String])
        case trending
        
        static private var urlPrefix = "/gifs"
        internal var urlComponents: String {
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
            internal var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Gif.urlPrefix + "/translate"
            internal var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/s?q=\(phrase)"
                }
            }
        }
        
        enum Random: GiphyRequestable {
            case tag(_: String)
            
            static private var urlPrefix = Gif.urlPrefix + "/random"
            internal var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .tag(let phrase): return url + "/tag?q=\(phrase)"
                }
            }
        }
        
    }
}


// MARK: - GiphyRequset: Sticker
extension GiphyRequest {
    enum Sticker: GiphyRequestable {
        
        case trending
        
        static private var urlPrefix = "/stickers"
        internal var urlComponents: String {
            let url = Sticker.urlPrefix
            
            switch self {
            case .trending: return url + "/trending"
            }
        }
        
        enum Search: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix
            internal var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/search?q=\(phrase)"
                }
            }
        }
        
        enum Translate: GiphyRequestable {
            case phrase(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/translate"
            internal var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .phrase(let phrase): return url + "/s?q=\(phrase)"
                }
            }
        }
        
        enum Random: GiphyRequestable {
            case tag(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/random"
            internal var urlComponents: String {
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
}

extension GiphyRequestable {
    var url: URL {
        let url = Giphy.baseUrl + urlComponents + "&api_key=\(Giphy.apiKey)"
        return URL(string: url)!
    }
}
