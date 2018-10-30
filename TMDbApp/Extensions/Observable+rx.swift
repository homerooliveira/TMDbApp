//
//  Observable+rx.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 29/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    /**
     Takes a sequence of optional elements and returns
     a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */
    
    public func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
