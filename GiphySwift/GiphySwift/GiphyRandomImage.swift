//
//  GiphyRandomImageResult.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/22/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public struct GiphyRandomImageResult: GiphyModelRequestable {
    
    let json: JSON
    
    init?(json: JSON) {
        self.json = json
    }
    
}
