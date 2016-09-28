//
//  Protocols.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/19/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

public protocol GiphyFileType {
    var url: String { get }
    var filesize: KByte? { get }
}

public protocol SizeAttributable {
    var size: (width: Int, height: Int) { get }
}

public protocol GifDrawable {
    var gif: Giphy.FileType.Gif { get }
}

public protocol Mp4Drawable {
    var mp4: Giphy.FileType.Mp4 { get }
}

public protocol WebPDrawable {
    var webP: Giphy.FileType.WebP { get }
}


// MARK: - GiphyImages
public protocol GiphyOriginalAnimatedImage: SizeAttributable, GifDrawable, Mp4Drawable, WebPDrawable {
    var frameCount: Int { get }
    var still: Giphy.Image.Still { get }
}

public protocol GiphyFixedSizeAnimatedImage: SizeAttributable, GifDrawable, Mp4Drawable, WebPDrawable {
    var downsampled: Giphy.Image.Downsampled { get }
    var small: Giphy.Image.Small { get }
    var still: Giphy.Image.Still { get }
}

public protocol GiphyDownsizedAnimatedImage: SizeAttributable, GifDrawable {
    var still: Giphy.Image.Still { get }
}

public protocol GiphyStillImage: SizeAttributable {
    var url: String { get }
}

public protocol GiphySmallImage: SizeAttributable, GifDrawable, WebPDrawable {
    var still: Giphy.Image.Still { get }
}

public protocol GiphyLargeImage: SizeAttributable, GifDrawable { }

public protocol GiphyDownsampledImage: GifDrawable, WebPDrawable { }


// MARK: - GiphyRandomImages
public protocol GiphyRandomOriginalAnimatedImage: SizeAttributable, GifDrawable {
    var frameCount: Int { get }
}

public protocol GiphyRandomDownsampledImage: GifDrawable { }

public protocol GiphyRandomSmallImage: GifDrawable { }

public protocol GiphyRandomFixedSizeAnimatedImage {
    var downsampled: Giphy.Image.RandomDownsampled { get }
}
