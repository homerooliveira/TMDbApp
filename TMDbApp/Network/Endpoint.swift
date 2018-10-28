//
//  Endpoint.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

enum Endpoint {
    case upcomingMovies
    case movieDetail(movieId: Int)
    case searchMovie(forKeyword: String)
}

extension Endpoint {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "api_key=c5850ed73901b8d268d0898a8a9d8bff"

    var url: URL? {
        switch self {
        case .upcomingMovies:
            return URL(string: Endpoint.baseUrl + "/movie/upcoming?\(Endpoint.apiKey)")
        case .movieDetail(let movieId):
            return URL(string: Endpoint.baseUrl + "/movie/\(movieId)?\(Endpoint.apiKey)")
        case .searchMovie(let forKeyword):
            let test = URLComponents()
            
            print(URL(string: Endpoint.baseUrl + "/search/movie?query=\(forKeyword)&\(Endpoint.apiKey)"))
            return URL(string: Endpoint.baseUrl + "/search/movie?query=\(forKeyword)&\(Endpoint.apiKey)")
        }
    }
}
