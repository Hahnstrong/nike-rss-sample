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
        
        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        getItunesAlbums()
    }
    
    func getItunesAlbums() {
        let feedURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/explicit.json"
        guard let url = URL(string: feedURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let feedDictionary = json["feed"] as? [String: Any],
                let results = feedDictionary["results"] as? [[String: Any]] else { return }
                
            self.itunesAlbums = results.compactMap {ItunesAlbum(dictionary: $0) }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    // MARK: - Table View Datasource Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let album = itunesAlbums[indexPath.row]
        if album.albumName == album.artistName {
            cell.textLabel?.text = album.albumName
        } else {
            cell.textLabel?.text = album.albumName + " - " + album.artistName
        }
        
        guard let albumImageUrl = URL(string: album.artworkUrl100) else { return UITableViewCell() }
        let data = try? Data(contentsOf: albumImageUrl)
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = RSSFeedDetailViewController()
        detailVC.itunesAlbum = itunesAlbums[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Itunes Album Object

class ItunesAlbum {
    let albumName: String
    let artistName: String
    let artworkUrl100: String
    let genre: [[String: Any]]
    let releaseDate: String
    let copyright: String
    let artistUrl: String
    
    private let albumNameKey = "name"
    private let artistNameKey = "artistName"
    private let artworkUrl100Key = "artworkUrl100"
    private let genreKey = "genres"
    private let releaseDateKey = "releaseDate"
    private let copyrightKey = "copyright"
    private let artistUrlKey = "artistUrl"
    
    init?(dictionary: [String: Any]) {
        guard let albumName = dictionary[albumNameKey] as? String,
            let artistName = dictionary[artistNameKey] as? String,
            let artworkUrl100 = dictionary[artworkUrl100Key] as? String,
            let genre = dictionary[genreKey] as? [[String: Any]],
            let releaseDate = dictionary[releaseDateKey] as? String,
            let copyright = dictionary[copyrightKey] as? String,
            let artistUrl = dictionary[artistUrlKey] as? String else { return nil }
        
        self.albumName = albumName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.genre = genre
        self.releaseDate = releaseDate
        self.copyright = copyright
        self.artistUrl = artistUrl
    }
}
