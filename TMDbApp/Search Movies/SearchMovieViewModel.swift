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
    
    let text = PublishSubject<String>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = BehaviorRelay<Bool>(value: false)
    let movies = BehaviorRelay<[Movie]>(value: [])
    var pageIndex: Int = 1
    let error = PublishSubject<Swift.Error>()
    private let disposeBag = DisposeBag()
    private var isAllLoaded = false
    
    init() {
        
    }
}
