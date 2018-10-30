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
    var disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        let cellIdentifier = String(describing: MovieTableViewCell.self)
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        viewModel.movies
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { (_, movie, cell: MovieTableViewCell) in
                cell.movie = movie
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { (movie) in
                let viewModel = DeatilMovieViewModel(movie: movie, api: self.viewModel.api)
                let viewController = DetailMovieViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willBeginDragging
                    .asObservable()
                    .subscribe(onNext: { _ in
                        let searchBar = self.searchController.searchBar
                        if searchBar.isFirstResponder {
                            searchBar.resignFirstResponder()
                        }
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.delegate = self
        
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search name or partial name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

    }
}

extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.text.onNext(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        viewModel.movies.accept([])
    }
}
