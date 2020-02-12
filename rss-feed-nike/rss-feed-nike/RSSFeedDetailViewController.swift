//
//  RSSFeedDetailViewController.swift
//  rss-feed-nike
//
//  Created by Caleb Strong on 2/11/20.
//  Copyright © 2020 Caleb Strong. All rights reserved.
//

import UIKit

class RSSFeedDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var itunesAlbum: ItunesAlbum?
    
    var viewContainer = UIView()
    var albumImage = UIImageView()
    var albumAndArtist = UILabel()
    var genre = UILabel()
    var releaseDate = UILabel()
    var copyright = UILabel()
    var itunesButton = UIButton()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let itunesAlbum = itunesAlbum else { return }
        
        guard let albumImageUrl = URL(string: itunesAlbum.artworkUrl100) else { return }
        let data = try? Data(contentsOf: albumImageUrl)
        if let imageData = data {
            let image = UIImage(data: imageData)
            albumImage.image = image
        }
        
        if itunesAlbum.albumName == itunesAlbum.artistName {
            albumAndArtist.text = itunesAlbum.albumName
        } else {
            albumAndArtist.text = itunesAlbum.albumName + " - " + itunesAlbum.artistName
        }
        
        let genreArrayKey = "name"
        var genreString = ""
        let genresStringArray = itunesAlbum.genre.map ({ $0[genreArrayKey] })
        for any in genresStringArray {
            guard let string = any as? String else { return }
            if string != "Music" {
                if genreString == "" {
                    genreString = genreString + string
                } else {
                    genreString = genreString + ", " + string
                }
            }
        }
        
        genre.text = genreString
        releaseDate.text = itunesAlbum.releaseDate
        copyright.text = itunesAlbum.copyright
        
        setupSubviews()
        itunesButton.addTarget(self, action: #selector(didTapItunesPage(_:)), for: .touchUpInside)
    }

    func setupSubviews() {
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumAndArtist.translatesAutoresizingMaskIntoConstraints = false
        genre.translatesAutoresizingMaskIntoConstraints = false
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        copyright.translatesAutoresizingMaskIntoConstraints = false
        itunesButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewContainer.backgroundColor = .white
        albumImage.contentMode = .scaleAspectFit
        albumAndArtist.textAlignment = .center
        genre.textAlignment = .center
        releaseDate.textAlignment = .center
        copyright.textAlignment = .center
        copyright.numberOfLines = 3
        copyright.lineBreakMode = .byWordWrapping
        itunesButton.setTitle("Itunes Page", for: .normal)
        itunesButton.backgroundColor = .systemBlue
        
        self.view.addSubview(viewContainer)
        viewContainer.addSubview(albumImage)
        viewContainer.addSubview(albumAndArtist)
        viewContainer.addSubview(genre)
        viewContainer.addSubview(releaseDate)
        viewContainer.addSubview(copyright)
        viewContainer.addSubview(itunesButton)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            viewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            albumImage.heightAnchor.constraint(equalToConstant: 250),
            albumImage.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            albumImage.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            albumImage.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            
            albumAndArtist.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 20),
            albumAndArtist.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            albumAndArtist.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            albumAndArtist.heightAnchor.constraint(equalToConstant: 20),
            
            genre.topAnchor.constraint(equalTo: albumAndArtist.bottomAnchor, constant: 20),
            genre.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            genre.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            genre.heightAnchor.constraint(equalToConstant: 20),
            
            releaseDate.topAnchor.constraint(equalTo: genre.bottomAnchor, constant: 20),
            releaseDate.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            releaseDate.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            releaseDate.heightAnchor.constraint(equalToConstant: 20),
            
            copyright.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 20),
            copyright.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            copyright.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            copyright.heightAnchor.constraint(equalToConstant: 70),
            
            itunesButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            itunesButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            itunesButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            itunesButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func didTapItunesPage(_ sender: UIButton) {
        guard let urlString = itunesAlbum?.artistUrl else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}
