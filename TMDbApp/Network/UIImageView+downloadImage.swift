//
//  UIImageView+downloadImage.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(endpoint: Endpoint) {
        kf.setImage(with: endpoint.url)
    }
    
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}
