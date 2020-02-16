//
//  rss_feed_nikeTests.swift
//  rss-feed-nikeTests
//
//  Created by Caleb Strong on 2/11/20.
//  Copyright © 2020 Caleb Strong. All rights reserved.
//

import XCTest
@testable import rss_feed_nike

class rss_feed_nikeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testJSONToObject() {
        let testJson =  [
            [ "genres": [
                [ "genreId" : "2", "name" : "Pop", "url" : "url2" ],
                [ "genreId" : "1", "name" : "Music", "url" : "url1" ]],
              "artistUrl": "artisturl1",
              "name": "To Die For",
              "artworkUrl100": "arturl1",
              "copyright": "A Capitol Records UK Release; ℗ 2020 Universal Music Operations Limited",
              "releaseDate": "2020-05-01",
              "artistName": "Sam Smith"
            ],
            [ "genres": [
                [ "genreId" : "2", "name" : "Pop", "url" : "url2" ],
                [ "genreId" : "1", "name" : "Music", "url" : "url1" ]],
              "artistUrl": "artisturl2",
              "name": "Gallery",
              "artworkUrl100": "arturl2",
              "copyright": "A Long Totally Real Copyright",
              "releaseDate": "2017-04-14",
              "artistName": "ARIZONA"
            ]
        ]
        
        let itunesTestAlbums = testJson.compactMap {ItunesAlbum(dictionary: $0) }
        let album1 = itunesTestAlbums[0]
        XCTAssertEqual(album1.albumName, "To Die For")
    }
}
