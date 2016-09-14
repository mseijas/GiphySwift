//
//  GiphyResult.swift
//  GiphySwift
//
//  Created by Matias Seijas on 9/13/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import Foundation

protocol GiphyImage { }
protocol GiphyImageDownsampled {
	var url: String { get }
	var size: (width: Int, height: Int) { get }

}

protocol GiphyWebPFile {

}

protocol GiphyMP4File {
	
}

/*
url: "http://media0.giphy.com/media/feqkVgjJpYtjy/200_d.gif",
                    width: "445",
                    height: "200",
                    size: "183225",
                    webp: "http://media0.giphy.com/media/feqkVgjJpYtjy/200_d.webp",
                    webp_size: "89516"
*/

public struct GiphyImageResult {

	struct Url {
    	let base: String
    	let bitly: String
    	let bitlyGif: String
    	let embed: String
    }

    struct User {
    	let username: String
    	let displayName: String?
    	let profileUrl: String?
    	let bannerUrl: String?
    	let avatarUrl: String?
    }

    struct Source {
    	let url: String
    	let topLevelDomain: String
    	let postUrl: String
    }

    struct Images {

    }

    private let json: JSON
//
//    let id: String
//    let slug: String
//    let url: Url
//    let user: User?
//    let source: Source
//    let rating: Giphy.Rating
//    let caption: String?
//    let contentUrl: String?
//
//    let importDate: Date
//    let trendingDate: Date
//
//    let images: Images
    
    init?(json: JSON) {
        self.json = json
    }
    
}

/*
user: {
                avatar_url: "https://media3.giphy.com/avatars/mrdiv.gif",
                banner_url: "",
                profile_url: "https://giphy.com/mrdiv/",
                username: "mrdiv",
                display_name: "mr. div"
              },
*/

/*
type: "gif",
            id: "FiGiRei2ICzzG",
            slug: "funny-cat-FiGiRei2ICzzG",

            url: "http://giphy.com/gifs/funny-cat-FiGiRei2ICzzG",
            bitly_gif_url: "http://gph.is/1fIdLOl",
            bitly_url: "http://gph.is/1fIdLOl",
            embed_url: "http://giphy.com/embed/FiGiRei2ICzzG",

            username: "",
            source: "http://tumblr.com",
            rating: "g",
            caption: "",
            content_url: "",

            source_tld: "tumblr.com",
            source_post_url: "http://tumblr.com",
            import_datetime: "2014-01-18 09:14:20",
            trending_datetime: "1970-01-01 00:00:00",
*/
