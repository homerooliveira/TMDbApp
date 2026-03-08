//
//  SearchMovieViewModel.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    let api = MoviesApi()
    let text = PublishSubject<String>()
    let movies = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    
    public init() {
        
        text.filter { !$0.isEmpty }
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] (text)  in
                self.api.request(for: .searchMovie(query: text), of: Page<Movie>.self)
            }
            .map { $0.results }
            .catchAndReturn([])
            .bind(to: movies)
            .disposed(by: disposeBag)
    }
}
