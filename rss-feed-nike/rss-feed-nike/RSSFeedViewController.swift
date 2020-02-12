//
//  RSSFeedViewController.swift
//  rss-feed-nike
//
//  Created by Caleb Strong on 2/11/20.
//  Copyright © 2020 Caleb Strong. All rights reserved.
//

import UIKit

class RSSFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var itunesAlbums: [ItunesAlbum] = []
    var tableView = UITableView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getItunesAlbums()
    }
    
    func getItunesAlbums() {
        let feedURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/explicit.json"
        guard let url = URL(string: feedURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("There was an error as dataTask function began: \(error)")
                return
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8),
                let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let results = jsonDictionary["results"] as? [[String: Any]]
            else {  return }
            
            print(responseDataString)
            self.itunesAlbums = results.compactMap {ItunesAlbum(dictionary: $0) }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Datasource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: - Itunes Album Object

class ItunesAlbum {
    let albumName: String
    let artistName: String
    let artworkUrl100: String
//    let genre: String
    let releaseDate: String
    let copyright: String
    
    private let albumNameKey = "artistName"
    private let artistNameKey = "name"
    private let artworkUrl100Key = "artworkUrl100"
//    private let genreKey = "genres"
    private let releaseDateKey = "releaseDate"
    private let copyrightKey = "copyright"
    
    init?(dictionary: [String: Any]) {
        guard let albumName = dictionary[albumNameKey] as? String,
            let artistName = dictionary[artistNameKey] as? String,
            let artworkUrl100 = dictionary[artworkUrl100Key] as? String,
            let releaseDate = dictionary[releaseDateKey] as? String,
            let copyright = dictionary[copyrightKey] as? String else { return nil }
        
        self.albumName = albumName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.releaseDate = releaseDate
        self.copyright = copyright
    }
}
