//
//  SearchResultCell.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak private var poster: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var releaseDate: UILabel!
    @IBOutlet weak private var overview: UILabel!
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
        let errorImage = #imageLiteral(resourceName: "errorImage")
        let noDataText = "N/A"
        
        if let posterURL = result.poster_path {
            let imageURL = MoviedbAPI.imageURL(size: .medium, path: posterURL)
            downloadTask = poster.loadImage(url: imageURL, errorImage: errorImage)
        } else {
            print("\(result.title) doesn't have poster -> Handled with an error image")
            poster.image = errorImage
        }
        name.text = result.title
        releaseDate.text = result.release_date ?? noDataText
        overview.text = result.overview ?? noDataText
    }
}
