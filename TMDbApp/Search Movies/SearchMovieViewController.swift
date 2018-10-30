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
        
        let text = searchController.searchBar.rx.text
            .orEmpty
        
        text.bind(to: viewModel.text)
            .disposed(by: disposeBag)
        
        viewModel.movies
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
