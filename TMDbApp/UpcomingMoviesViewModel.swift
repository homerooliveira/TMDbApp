//
//  UpcomingMoviesViewModel.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 27/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import RxSwift

final class UpcomingMoviesViewModel {
    let api = MoviesApi()

    let upcomingMovies: Observable<[Movie]>

    init() {
        upcomingMovies = api.request(for: .upcomingMovies,
                                     of: Page<Movie>.self)
            .map { $0.results }
            .asObservable()
    }
}
