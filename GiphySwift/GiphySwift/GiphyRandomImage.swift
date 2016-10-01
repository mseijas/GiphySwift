//
//  GiphyRandomImageResult.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/22/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public struct GiphyRandomImageResult: GiphyImage, GiphyModelRequestable {
    
    public struct Images {
        public let fixedHeight: Giphy.Image.RandomFixedHeight
        public let fixedWidth: Giphy.Image.RandomFixedWidth
        public let original: Giphy.Image.RandomOriginal
    }
    
    public let type: String
    public let id: String
    public let url: String
    public let user: Giphy.User?
    public let caption: String?
    
    public let images: Images
    
    init?(json: JSON) {
        guard let fixedHeightDownsampledUrl = json["fixed_height_downsampled_url"] as? String,
            let fixedHeightDownsampledWidthString = json["fixed_height_downsampled_width"] as? String,
            let fixedHeightDownsampledWidth = Int(fixedHeightDownsampledWidthString),
            let fixedHeightDownsampledHeightString = json["fixed_height_downsampled_height"] as? String,
            let fixedHeightDownsampledHeight = Int(fixedHeightDownsampledHeightString)
        else {
            print("[GiphySwift] Warning: Could not parse FixedHeight JSON random image properties")
            return nil
        }
        
        guard let fixedHeightSmallUrl = json["fixed_height_small_url"] as? String,
            let fixedHeightSmallWidthString = json["fixed_height_small_width"] as? String,
            let fixedHeightSmallWidth = Int(fixedHeightSmallWidthString),
            let fixedHeightSmallHeightString = json["fixed_height_small_height"] as? String,
            let fixedHeightSmallHeight = Int(fixedHeightSmallHeightString)
        else {
            print("[GiphySwift] Warning: Could not parse FixedHeight.Small JSON random image properties")
            return nil
        }
        
        guard let fixedHeightSmallStillUrl = json["fixed_height_small_still_url"] as? String
        else {
            print("[GiphySwift] Warning: Could not parse FixedHeight.SmallStill JSON random image properties")
            return nil
        }
        
        guard let fixedWidthDownsampledUrl = json["fixed_width_downsampled_url"] as? String,
            let fixedWidthDownsampledWidthString = json["fixed_width_downsampled_width"] as? String,
            let fixedWidthDownsampledWidth = Int(fixedWidthDownsampledWidthString),
            let fixedWidthDownsampledHeightString = json["fixed_width_downsampled_height"] as? String,
            let fixedWidthDownsampledHeight = Int(fixedWidthDownsampledHeightString)
            else {
                print("[GiphySwift] Warning: Could not parse FixedWidth JSON random image properties")
                return nil
        }
        
        guard let fixedWidthSmallUrl = json["fixed_width_small_url"] as? String,
            let fixedWidthSmallWidthString = json["fixed_width_small_width"] as? String,
            let fixedWidthSmallWidth = Int(fixedWidthSmallWidthString),
            let fixedWidthSmallHeightString = json["fixed_width_small_height"] as? String,
            let fixedWidthSmallHeight = Int(fixedWidthSmallHeightString)
            else {
                print("[GiphySwift] Warning: Could not parse FixedWidth.Small JSON random image properties")
                return nil
        }
        
        guard let fixedWidthSmallStillUrl = json["fixed_width_small_still_url"] as? String
            else {
                print("[GiphySwift] Warning: Could not parse FixedWidth.SmallStill JSON random image properties")
                return nil
        }
        
        guard let type = json["type"] as? String,
            type == "gif",
            let id = json["id"] as? String,
            let url = json["url"] as? String,
            let gifUrl = json["image_original_url"] as? String,
            let mp4Url = json["image_mp4_url"] as? String,
            let frameCountString = json["image_frames"] as? String,
            let frameCount = Int(frameCountString),
            let widthString = json["image_width"] as? String,
            let width = Int(widthString),
            let heightString = json["image_height"] as? String,
            let height = Int(heightString),
            let caption = json["caption"] as? String?,
            let username = json["username"] as? String?
        else {
            print("[GiphySwift] Warning: Could not parse RandomImage JSON random image properties")
            return nil
        }
        

        // MARK: - Fixed Height
        let fixedHeightDownsampled = Giphy.Image.RandomDownsampled(size: (width: fixedHeightDownsampledWidth, height: fixedHeightDownsampledHeight),
                                                                   gif: Giphy.FileType.Gif(url: fixedHeightDownsampledUrl, filesize: nil))
        
        let fixedHeightSmallStill = Giphy.Image.RandomStill(size: (width: fixedHeightSmallWidth, height: fixedHeightSmallHeight), url: fixedHeightSmallStillUrl)
        
        let fixedHeightSmall = Giphy.Image.RandomSmall(size: (width: fixedHeightSmallWidth, height: fixedHeightSmallHeight),
                                                       gif: Giphy.FileType.Gif(url: fixedHeightSmallUrl, filesize: nil),
                                                       still: fixedHeightSmallStill)
        
        let fixedHeight = Giphy.Image.RandomFixedHeight(downsampled: fixedHeightDownsampled, small: fixedHeightSmall, still: fixedHeightSmallStill)
        
        
        // MARK: - Fixed Width
        let fixedWidthDownsampled = Giphy.Image.RandomDownsampled(size: (width: fixedWidthDownsampledWidth, height: fixedWidthDownsampledHeight),
                                                                   gif: Giphy.FileType.Gif(url: fixedWidthDownsampledUrl, filesize: nil))
        
        let fixedWidthSmallStill = Giphy.Image.RandomStill(size: (width: fixedWidthSmallWidth, height: fixedWidthSmallHeight), url: fixedWidthSmallStillUrl)
        
        let fixedWidthSmall = Giphy.Image.RandomSmall(size: (width: fixedWidthSmallWidth, height: fixedWidthSmallHeight),
                                                       gif: Giphy.FileType.Gif(url: fixedWidthSmallUrl, filesize: nil),
                                                       still: fixedWidthSmallStill)
        
        let fixedWidth = Giphy.Image.RandomFixedWidth(downsampled: fixedWidthDownsampled, small: fixedWidthSmall, still: fixedWidthSmallStill)
        
        
        // MARK: - Original
        let original = Giphy.Image.RandomOriginal(size: (width: width, height: height),
                                                  frameCount: frameCount,
                                                  gif: Giphy.FileType.Gif(url: gifUrl, filesize: nil),
                                                  mp4: Giphy.FileType.Mp4(url: mp4Url, filesize: nil))
        
        self.id = id
        self.type = type
        self.url = url
        self.caption = caption
        self.user = Giphy.User(username: username)
        self.images = Images(fixedHeight: fixedHeight, fixedWidth: fixedWidth, original: original)
    }
    
}
