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
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = Variable<Bool>(false)
    let movies = Variable<[Movie]>([])
    var pageIndex: Int = 1
    let error = PublishSubject<Swift.Error>()
    private let disposeBag = DisposeBag()
    
    private var isAllLoaded = false
    
    public init() {
        
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { observer in
                        self.pageIndex = 1
                        print("reset page index to 0")
                        observer.onNext(1)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
            }
            .debug("refreshRequest", trimOutput: true)
        
        let nextPageRequest = loading.asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    guard !self.isAllLoaded else { return Observable.empty() }
                    
                    return Observable<Int>.create { [unowned self] observer in
                        self.pageIndex += 1
                        print(self.pageIndex)
                        observer.onNext(self.pageIndex)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
            }
            .debug("nextPageRequest", trimOutput: true)
        
        let request = Observable.merge(refreshRequest, nextPageRequest)
            .share(replay: 1)
            .debug("😀 Start request", trimOutput: true)
        
        let response = request.flatMapLatest { page in
             self.api.request(for: Endpoint.upcomingMovies(page: page),
                              of: Page<Movie>.self)
            }
            .share(replay: 1)
            .debug("😈 Start response", trimOutput: true)
        
        Observable
            .combineLatest(request, response, movies.asObservable()) { request, response, movies in
                self.isAllLoaded = !response.hasNextPage
                return self.pageIndex == 1 ? response.results : movies + response.results
            }
            .sample(response)
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        Observable
            .merge(request.map{_ in true},
                   response.map { _ in false },
                   error.map { _ in false })
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
    
}
