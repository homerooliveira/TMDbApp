//
//  MovieDetail.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

struct MovieDetails: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let genres: [Genre]
    let releaseDate: String
}
