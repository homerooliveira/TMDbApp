//
//  MovieTableViewCell.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return  }
            titleLabel.text = movie.title
            guard let path = movie.posterPath else { return }
            posterImageView.downloadImage(endpoint: .poster(path: path))
        }
    }
}
