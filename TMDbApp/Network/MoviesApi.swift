//
//  MoviesApi.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MoviesApi {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return decoder
    }()

    func request<T: Decodable>(for endpoint: Endpoint, of type: T.Type) -> Single<T> {
        guard let url = endpoint.url else {
            return Single.error(RxCocoaURLError.unknown)
        }

        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map { data in
                return try self.decoder.decode(T.self, from: data)
            }
            .asSingle()
    }
}
