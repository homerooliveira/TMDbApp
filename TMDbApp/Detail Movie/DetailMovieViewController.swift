//
//  DetailMovieViewController.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 28/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit
import RxSwift

final class DetailMovieViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    let viewModel: DeatilMovieViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: DeatilMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.movie
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie
            .map { $0.overview }
            .bind(to: overviewTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie
            .map { $0.posterPath }
            .unwrap()
            .flatMap { path in
                self.posterImageView.rx.downloadImage(endpoint: .poster(path: path)) }
            .subscribe()
            .disposed(by: disposeBag)
    }

}
