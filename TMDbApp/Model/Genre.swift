//
//  Genre.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

struct Genre: Decodable, Identifiable, Sendable {
    let id: Int
    let name: String
}
