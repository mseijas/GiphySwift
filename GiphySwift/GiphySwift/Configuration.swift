//
//  Configuration.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

struct Configuration {
    
    static var host: String {
        return "api.giphy.com"
    }
    
    static var apiVersion: String {
        return "v1"
    }
    
    static var publicApiKey: String {
        return "dc6zaTOxFJmzC"
    }
    
    static var baseUrl: String {
        return "https://\(host)/\(apiVersion)"
    }
    
}
