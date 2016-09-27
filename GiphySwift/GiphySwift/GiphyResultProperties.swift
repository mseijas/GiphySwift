//
//  GiphyResultProperties.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/14/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public struct GiphyResultProperties {
    let count: Int
    let offset: Int
    let totalCount: Int?
    
    init?(json: JSON) {
        guard let count = json["count"] as? Int,
            let offset = json["offset"] as? Int else { return nil }
        
        self.count = count
        self.offset = offset
        self.totalCount = json["total_count"] as? Int
    }
    
    init?(with object: AnyObject?) {
        guard let pagination = object as? JSON else { return nil }
        self.init(json: pagination)
    }
    
}
