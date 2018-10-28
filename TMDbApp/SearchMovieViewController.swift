//
//  SearchMovieViewController.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 28/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import RxSwift

final class SearchMovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        searchController.searchBar.rx.text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .debug()
            .flatMapLatest { (text) in
                return Observable.just(" ")
        }.debug()
        .subscribe()
        
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search name or partial name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

    }
}
