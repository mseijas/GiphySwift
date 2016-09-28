//
//  Models.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/19/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation


extension Giphy {
    
    public struct Image {
        public struct FixedHeight: GiphyFixedSizeAnimatedImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            public let mp4: FileType.Mp4
            public let webP: FileType.WebP
            
            public let downsampled: Image.Downsampled
            public let small: Image.Small
            public let still: Image.Still
            
            init?(fixedHeight: JSON, downsampled: Image.Downsampled, small: Image.Small, still: Image.Still) {
                guard let widthString = fixedHeight["width"] as? String,
                    let width = Int(widthString),
                    let heightString = fixedHeight["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = fixedHeight["url"] as? String,
                    let gifFilesizeString = fixedHeight["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString),
                    let mp4Url = fixedHeight["mp4"] as? String,
                    let mp4FilesizeString = fixedHeight["mp4_size"] as? String,
                    let mp4Filesize = Int(mp4FilesizeString),
                    let webPUrl = fixedHeight["webp"] as? String,
                    let webPFilesizeString = fixedHeight["webp_size"] as? String,
                    let webPFilesize = Int(webPFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.FixedHeight due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.mp4 = FileType.Mp4(url: mp4Url, filesize: mp4Filesize)
                self.webP = FileType.WebP(url: webPUrl, filesize: webPFilesize)
                self.downsampled = downsampled
                self.small = small
                self.still = still
            }
        }
        
        public struct FixedWidth: GiphyFixedSizeAnimatedImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            public let mp4: FileType.Mp4
            public let webP: FileType.WebP
            
            public let downsampled: Image.Downsampled
            public let small: Image.Small
            public let still: Image.Still
            
            init?(fixedWidth: JSON, downsampled: Image.Downsampled, small: Image.Small, still: Image.Still) {
                guard let widthString = fixedWidth["width"] as? String,
                    let width = Int(widthString),
                    let heightString = fixedWidth["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = fixedWidth["url"] as? String,
                    let gifFilesizeString = fixedWidth["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString),
                    let mp4Url = fixedWidth["mp4"] as? String,
                    let mp4FilesizeString = fixedWidth["mp4_size"] as? String,
                    let mp4Filesize = Int(mp4FilesizeString),
                    let webPUrl = fixedWidth["webp"] as? String,
                    let webPFilesizeString = fixedWidth["webp_size"] as? String,
                    let webPFilesize = Int(webPFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.FixedWidth due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.mp4 = FileType.Mp4(url: mp4Url, filesize: mp4Filesize)
                self.webP = FileType.WebP(url: webPUrl, filesize: webPFilesize)
                self.downsampled = downsampled
                self.small = small
                self.still = still
            }
        }
        
        public struct Downsized: GiphyDownsizedAnimatedImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            
            public let still: Image.Still
            public let large: Image.Large
            
            init?(json: JSON, still: Image.Still, large: Image.Large) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = json["url"] as? String,
                    let gifFilesizeString = json["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.Downsized due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.still = still
                self.large = large
            }
        }
        
        public struct Original: GiphyOriginalAnimatedImage {
            public let size: (width: Int, height: Int)
            public let frameCount: Int
            
            public let gif: FileType.Gif
            public let mp4: FileType.Mp4
            public let webP: FileType.WebP
            
            public let still: Image.Still
            
            init?(json: JSON, still: Image.Still) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let frameCountString = json["frames"] as? String,
                    let frameCount = Int(frameCountString),
                    let gifUrl = json["url"] as? String,
                    let gifFilesizeString = json["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString),
                    let mp4Url = json["mp4"] as? String,
                    let mp4FilesizeString = json["mp4_size"] as? String,
                    let mp4Filesize = Int(mp4FilesizeString),
                    let webPUrl = json["webp"] as? String,
                    let webPFilesizeString = json["webp_size"] as? String,
                    let webPFilesize = Int(webPFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.Original due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.frameCount = frameCount
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.mp4 = FileType.Mp4(url: mp4Url, filesize: mp4Filesize)
                self.webP = FileType.WebP(url: webPUrl, filesize: webPFilesize)
                self.still = still
            }
        }
        
        public struct RandomFixedHeight: GiphyRandomFixedSizeAnimatedImage {
            public let downsampled: Image.RandomDownsampled
            public let small: Image.RandomSmall
            public let still: Image.RandomStill
        }
        
        public struct RandomFixedWidth: GiphyRandomFixedSizeAnimatedImage {
            public let downsampled: Image.RandomDownsampled
            public let small: Image.RandomSmall
            public let still: Image.RandomStill
        }
        
        public struct RandomOriginal: GiphyRandomOriginalAnimatedImage {
            public let size: (width: Int, height: Int)
            public let frameCount: Int
            
            public let gif: FileType.Gif
            public let mp4: FileType.Mp4
        }
        
        
        // MARK: - ImageType
        public struct Small: GiphySmallImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            public let webP: FileType.WebP
            public let still: Image.Still
            
            init?(json: JSON, still: Image.Still) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = json["url"] as? String,
                    let gifFilesizeString = json["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString),
                    let webPUrl = json["webp"] as? String,
                    let webPFilesizeString = json["webp_size"] as? String,
                    let webPFilesize = Int(webPFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.Small due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.webP = FileType.WebP(url: webPUrl, filesize: webPFilesize)
                self.still = still
            }
        }
        
        public struct Large: GiphyLargeImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            
            init?(json: JSON) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = json["url"] as? String,
                    let gifFilesizeString = json["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.Large due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
            }
        }
        
        public struct Still: GiphyStillImage {
            public let size: (width: Int, height: Int)
            public let url: String
            
            init?(json: JSON) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let url = json["url"] as? String
                else {
                    print("[GiphySwift] Warning: Could not init Image.Still due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.url = url
            }
        }
        
        public struct Downsampled: GiphyDownsampledImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            public let webP: FileType.WebP
            
            init?(json: JSON) {
                guard let widthString = json["width"] as? String,
                    let width = Int(widthString),
                    let heightString = json["height"] as? String,
                    let height = Int(heightString),
                    let gifUrl = json["url"] as? String,
                    let gifFilesizeString = json["size"] as? String,
                    let gifFilesize = Int(gifFilesizeString),
                    let webPUrl = json["webp"] as? String,
                    let webPFilesizeString = json["webp_size"] as? String,
                    let webPFilesize = Int(webPFilesizeString)
                else {
                    print("[GiphySwift] Warning: Could not init Image.Downsampled due to a JSON parsing error")
                    return nil
                }
                
                self.size = (width: width, height: height)
                self.gif = FileType.Gif(url: gifUrl, filesize: gifFilesize)
                self.webP = FileType.WebP(url: webPUrl, filesize: webPFilesize)
            }
        }
        
        public struct RandomStill: GiphyStillImage {
            public let size: (width: Int, height: Int)
            public let url: String
        }
        
        public struct RandomDownsampled: GiphyRandomDownsampledImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
        }
        
        public struct RandomSmall: GiphyRandomSmallImage {
            public let size: (width: Int, height: Int)
            public let gif: FileType.Gif
            public let still: Image.RandomStill
        }
        
    }
    
    // MARK: - FileType
    public struct FileType {
        public struct Gif: GiphyFileType {
            public let url: String
            public let filesize: KByte?
        }
        
        public struct WebP: GiphyFileType {
            public let url: String
            public let filesize: KByte?
        }
        
        public struct Mp4: GiphyFileType {
            public let url: String
            public let filesize: KByte?
        }
    }
}
