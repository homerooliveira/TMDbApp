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
    let api = MoviesApi()
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        let searchResults = searchController.searchBar.rx.text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest { (text) in
                self.api.request(for: .searchMovie(forKeyword: text), of: Page<Movie>.self).asObservable()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchResults
            .map { $0.results }
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (_, movie, cell) in
                cell.textLabel?.text = movie.title
            }
            .disposed(by: disposeBag)
        
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search name or partial name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

    }
}
