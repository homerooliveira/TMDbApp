//
//  UIImageView+downloadImage.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import Kingfisher

enum ImageEndpoint {
    case poster(path: String)
}

extension ImageEndpoint {
    
    static let baseUrl = "https://image.tmdb.org/t/p"
    
    var url: URL? {
        switch self {
        case .poster(let path):
            return URL(string: "\(ImageEndpoint.baseUrl)/w154\(path)")
        }
    }
}

extension UIImageView {
    func downloadImage(endpoint: ImageEndpoint) {
        kf.indicatorType = .activity
        kf.setImage(with: endpoint.url)
    }
    
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}
