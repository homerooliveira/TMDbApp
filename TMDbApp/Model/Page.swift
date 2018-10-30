//
//  Page.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

struct Page<T>: Decodable where T: Decodable {
    let results: [T]
    let page: Int
    let totalResults: Int
    let totalPages: Int
}

extension Page {
    var hasNextPage: Bool {
        return page <= totalPages
    }
}
