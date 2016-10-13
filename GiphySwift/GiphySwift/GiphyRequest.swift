//
//  Request.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public struct GiphyRequest { }

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
                case .search(let phrase):
                    let phrase = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? phrase
                    return url + "/search?q=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Translate: GiphyRequestable {
            case translate(_: String)
            
            static private var urlPrefix = Gif.urlPrefix + "/translate"
            var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .translate(let phrase):
                    let phrase = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? phrase
                    return url + "?s=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case random(tag: String?)
            
            static private var urlPrefix = Gif.urlPrefix
            var urlComponents: String {
                let url = Random.urlPrefix + "/random"
                
                switch self {
                case .random(let tag):
                    if let tag = tag {
                        let tag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? tag
                        return url + "?tag=\(tag.replacingOccurrences(of: " ", with: "+"))"
                    }
                    return url
                }
            }
        }
        
    }
}


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
            case search(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix
            var urlComponents: String {
                let url = Search.urlPrefix
                
                switch self {
                case .search(let phrase):
                    let phrase = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? phrase
                    return url + "/search?q=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Translate: GiphyRequestable {
            case translate(_: String)
            
            static private var urlPrefix = Sticker.urlPrefix + "/translate"
            var urlComponents: String {
                let url = Translate.urlPrefix
                
                switch self {
                case .translate(let phrase):
                    let phrase = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? phrase
                    return url + "?s=\(phrase.replacingOccurrences(of: " ", with: "+"))"
                }
            }
        }
        
        public enum Random: GiphyRequestable {
            case random(tag: String?)
            
            static private var urlPrefix = Sticker.urlPrefix + "/random"
            var urlComponents: String {
                let url = Random.urlPrefix
                
                switch self {
                case .random(let tag):
                    if let tag = tag {
                        let tag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? tag
                        return url + "?tag=\(tag.replacingOccurrences(of: " ", with: "+"))"
                    }
                    return url
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
        var url = Configuration.baseUrl + urlComponents
        if urlComponents.range(of: "?q=") != nil || urlComponents.range(of: "?s=") != nil || urlComponents.range(of: "?ids=") != nil || urlComponents.range(of: "?tag=") != nil {
            url += "&api_key=\(Giphy.apiKey)"
        } else {
            url += "?api_key=\(Giphy.apiKey)"
        }
        
        return URL(string: url)!
    }
}
