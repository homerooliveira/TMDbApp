//
//  DetailMovie.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import RxSwift

final class DeatilMovieViewModel {
    let movie: Observable<Movie>
    let movieDetails: Observable<MovieDetails>
    
    init(movie: Movie, api: MoviesApi) {
        self.movie = Observable.just(movie)
        self.movieDetails = api.request(for: .movieDetail(movieId: movie.id),
                                        of: MovieDetails.self)
                                .asObservable()
                                .share(replay: 1, scope: .whileConnected)
    }
}
