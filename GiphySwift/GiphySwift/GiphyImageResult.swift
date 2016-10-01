//
//  GiphyResult.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

protocol GiphyModelRequestable {
    init?(json: JSON)
}

public protocol GiphyImage { }


public struct GiphyImageResult: GiphyImage, GiphyModelRequestable {
    
    public struct Images {
        public let fixedHeight: Giphy.Image.FixedHeight
        public let fixedWidth: Giphy.Image.FixedWidth
        public let original: Giphy.Image.Original
        public let downsized: Giphy.Image.Downsized
        
        init?(json: JSON) {
            guard let fixedHeightStillJSON = json["fixed_height_still"] as? JSON,
                let fixedHeightDownsampledJSON = json["fixed_height_downsampled"] as? JSON,
                let fixedHeightSmallStillJSON = json["fixed_height_small_still"] as? JSON,
                let fixedHeightSmallJSON = json["fixed_height_small"] as? JSON,
                let fixedHeightJSON = json["fixed_height"] as? JSON
            else {
                print("[GiphySwift] Warning: Could not parse FixedHeight JSON image properties")
                return nil
            }
            
            guard let fixedWidthStillJSON = json["fixed_width_still"] as? JSON,
                let fixedWidthDownsampledJSON = json["fixed_width_downsampled"] as? JSON,
                let fixedWidthSmallStillJSON = json["fixed_width_small_still"] as? JSON,
                let fixedWidthSmallJSON = json["fixed_width_small"] as? JSON,
                let fixedWidthJSON = json["fixed_width"] as? JSON
            else {
                print("[GiphySwift] Warning: Could not parse FixedWidth JSON image properties")
                return nil
            }
            
            guard let downsizedStillJSON = json["downsized_still"] as? JSON,
                let downsizedLargeJSON = json["downsized_large"] as? JSON,
                let downsizedJSON = json["downsized"] as? JSON
            else {
                print("[GiphySwift] Warning: Could not parse Downsized JSON image properties")
                return nil
            }
            
            guard let originalStillJSON = json["original_still"] as? JSON,
                let originalJSON = json["original"] as? JSON
            else {
                print("[GiphySwift] Warning: Could not parse Original JSON image properties")
                return nil
            }
            
            guard let fixedHeightStill = Giphy.Image.Still(json: fixedHeightStillJSON),
                let fixedHeightDownsampled = Giphy.Image.Downsampled(json: fixedHeightDownsampledJSON),
                let fixedHeightSmallStill = Giphy.Image.Still(json: fixedHeightSmallStillJSON),
                let fixedHeightSmall = Giphy.Image.Small(json: fixedHeightSmallJSON, still: fixedHeightSmallStill),
                let fixedHeight = Giphy.Image.FixedHeight(fixedHeight: fixedHeightJSON, downsampled: fixedHeightDownsampled, small: fixedHeightSmall, still: fixedHeightStill)
            else { return nil }
            
            self.fixedHeight = fixedHeight
            
            guard let fixedWidthStill = Giphy.Image.Still(json: fixedWidthStillJSON),
                let fixedWidthDownsampled = Giphy.Image.Downsampled(json: fixedWidthDownsampledJSON),
                let fixedWidthSmallStill = Giphy.Image.Still(json: fixedWidthSmallStillJSON),
                let fixedWidthSmall = Giphy.Image.Small(json: fixedWidthSmallJSON, still: fixedWidthSmallStill),
                let fixedWidth = Giphy.Image.FixedWidth(fixedWidth: fixedWidthJSON, downsampled: fixedWidthDownsampled, small: fixedWidthSmall, still: fixedWidthStill)
            else { return nil }
            
            self.fixedWidth = fixedWidth
            
            guard let downsizedStill = Giphy.Image.Still(json: downsizedStillJSON),
                let downsizedLarge = Giphy.Image.Large(json: downsizedLargeJSON),
                let downsized = Giphy.Image.Downsized(json: downsizedJSON, still: downsizedStill, large: downsizedLarge)
            else { return nil }
            
            self.downsized = downsized
            
            guard let originalStill = Giphy.Image.Still(json: originalStillJSON),
                let original = Giphy.Image.Original(json: originalJSON, still: originalStill)
            else { return nil }
            
            self.original = original
        }
    }

    public let id: String
    public let slug: String
    public let url: Giphy.Url
    public let source: Giphy.Source
    public let user: Giphy.User?
    public let rating: Giphy.Rating
    public let caption: String?
    public let contentUrl: String?
    
    public let importDate: Date
    public let trendingDate: Date

    public let images: Images
    
    init?(json: JSON) {
        guard let id = json["id"] as? String,
            let slug = json["slug"] as? String,
            let url = json["url"] as? String,
            let bitlyUrl = json["bitly_url"] as? String,
            let bitlyGifUrl = json["bitly_gif_url"] as? String,
            let embedUrl = json["embed_url"] as? String,
            let username = json["username"] as? String?,
            let sourceUrl = json["source"] as? String,
            let sourceTld = json["source_tld"] as? String,
            let sourcePostUrl = json["source_post_url"] as? String,
            let caption = json["caption"] as? String?,
            let contentUrl = json["content_url"] as? String?,
            let ratingString = json["rating"] as? String,
            let rating = Giphy.Rating(rawValue: ratingString),
            let importDateString = json["import_datetime"] as? String,
            let importDate = Giphy.dateFormatter.date(from: importDateString),
            let trendingDateString = json["trending_datetime"] as? String,
            let trendingDate = Giphy.dateFormatter.date(from: trendingDateString),
            let imagesJSON = json["images"] as? JSON,
            let images = Images(json: imagesJSON)
        else { return nil }
        
        if let user = json["user"] as? JSON {
            let username = user["username"] as? String
            let displayName = user["display_name"] as? String
            let profileUrl = user["profile_url"] as? String
            let bannerUrl = user["banner_url"] as? String
            let avatarUrl = user["avatar_url"] as? String
            
            self.user = Giphy.User(username: username, displayName: displayName, profileUrl: profileUrl, bannerUrl: bannerUrl, avatarUrl: avatarUrl)
        } else {
            self.user = Giphy.User(username: username)
        }
        
        self.id = id
        self.slug = slug
        self.url = Giphy.Url(base: url, bitly: bitlyUrl, bitlyGif: bitlyGifUrl, embed: embedUrl)
        self.source = Giphy.Source(url: sourceUrl, topLevelDomain: sourceTld, postUrl: sourcePostUrl)
        self.rating = rating
        self.caption = caption
        self.contentUrl = contentUrl
        self.importDate = importDate
        self.trendingDate = trendingDate
        self.images = images
    }
    
}
