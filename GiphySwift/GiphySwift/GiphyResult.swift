//
//  GiphyResult.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/14/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public enum GiphyResult<T> {
    case success(result: T, properties: GiphyResultProperties?)
    case error(_: Error)
}
