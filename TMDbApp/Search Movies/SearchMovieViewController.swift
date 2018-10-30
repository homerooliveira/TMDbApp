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
        
        let cellIdentifier = String(describing: MovieTableViewCell.self)
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        searchController.searchBar.rx.text
            .orEmpty
            .filter { !$0.isEmpty }
            .throttle(0.3, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .flatMapLatest { (text) in
                self.api.request(for: .searchMovie(query: text), of: Page<Movie>.self).asObservable()
            }
            .map { $0.results }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { (_, movie, cell: MovieTableViewCell) in
                cell.movie = movie
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
