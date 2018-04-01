//
//  SearchResultCell.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UILabel!
    private var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        poster.rounded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        poster.image = nil
        downloadTask?.cancel()
        downloadTask = nil
    }

    // MARK: - Boundary Methods
    func configure(_ result: Movie.Result) {
        if let posterURL = result.poster_path {
            let imageURL = MoviedbAPI.imageURL(size: .medium, path: posterURL)
            downloadTask = poster.loadImage(url: imageURL)
        } else {
            print("\(result.title) doesn't have poster")
            poster.image = UIImage(imageLiteralResourceName: "noImage")
        }
        name.text = result.title
        releaseDate.text = result.release_date
        overview.text = result.overview
    }
}
