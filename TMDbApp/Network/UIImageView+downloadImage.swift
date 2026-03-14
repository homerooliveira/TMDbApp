//
//  UIImageView+downloadImage.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

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
        kf.setImage(with: endpoint.url, placeholder: UIImage(named: "placeholder"))
    }

    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}

@MainActor
extension Reactive where Base: UIImageView {
    func downloadImage(endpoint: ImageEndpoint) -> Completable {
        return Completable.create(subscribe: { (observer) -> Disposable in
            self.base.kf.setImage(with: endpoint.url, completionHandler: { result in
                switch result {
                case .success:
                    observer(.completed)
                case .failure(let error):
                    observer(.error(error))
                }
            })
            return Disposables.create {
                self.base.cancelDownload()
            }
        })
    }
}
