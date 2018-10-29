//
//  ViewController.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 25/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UpcomingMoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel: UpcomingMoviesViewModel
    let disposeBag = DisposeBag()

    init(viewModel: UpcomingMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellIdentifier = String(describing: MovieTableViewCell.self)
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        viewModel.movies
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { (_, movie: Movie, cell: MovieTableViewCell) in
                cell.movie = movie
            }
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom
                    .asObservable()
                    .bind(to: viewModel.loadNextPageTrigger)
                    .disposed(by: disposeBag)
        
        viewModel.refreshTrigger.onNext(())
    }

}
