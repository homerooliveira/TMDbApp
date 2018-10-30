//
//  UpcomingMoviesViewModel.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 27/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class UpcomingMoviesViewModel {
    
    let api = MoviesApi()
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = BehaviorRelay<Bool>(value: false)
    let movies = BehaviorRelay<[Movie]>(value: [])
    let pageIndex = BehaviorRelay<Int>(value: 1)
    private let disposeBag = DisposeBag()
    private var isAllLoaded = false
    
    public init() {
        
        let refreshPageRequest = makeRefreshRequest()
        let nextPageRequest = makeNextPageRequest()
        
        let pageRequest = Observable.merge(refreshPageRequest, nextPageRequest)
            .share(replay: 1)
        
        pageRequest.bind(to: pageIndex)
            .disposed(by: disposeBag)
        
        let response = pageRequest.flatMapLatest { page in
            self.api.request(for: Endpoint.upcomingMovies(page: page),
                             of: Page<Movie>.self)
            }.share(replay: 1)
        
        bindToMovies(from: response)
        
        Observable
            .merge(pageRequest.map { _ in true },
                   response.map { _ in false })
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
    
    private func makeRefreshRequest() -> Observable<Int> {
        return refreshTrigger
            .withLatestFrom(loading)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable.just(1)
                }
        }
    }
    
    private func makeNextPageRequest() -> Observable<Int> {
        return loadNextPageTrigger
            .withLatestFrom(loading)
            .flatMap { [unowned self] loading -> Observable<Int> in
                guard !self.isAllLoaded && !loading else { return Observable.empty() }
                return Observable.just(self.pageIndex.value + 1)
        }
    }
    
    private func bindToMovies(from response: Observable<Page<Movie>>) {
        Observable
            .combineLatest(response, self.movies) {[unowned self] response, movies in
                self.isAllLoaded = !response.hasNextPage
                return self.pageIndex.value == 1 ? response.results : movies + response.results
            }
            .sample(response)
            .bind(to: self.movies)
            .disposed(by: disposeBag)
    }
}
