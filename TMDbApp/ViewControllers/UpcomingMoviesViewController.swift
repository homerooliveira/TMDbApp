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

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewModel.refreshTrigger.onNext(())
        
        viewModel.movies
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (_, movie, cell) in
                cell.textLabel?.text = movie.title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom
                    .asObservable()
                    .bind(to: viewModel.loadNextPageTrigger)
                    .disposed(by: disposeBag)
    }

}
