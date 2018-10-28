//
//  MoviesTabBarController.swift
//  TMDbApp
//
//  Created by Homero Oliveira on 27/10/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

final class MoviesTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)

        let moviesViewController = makeUpcomingMoviesViewController()

        viewControllers = [moviesViewController]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUpcomingMoviesViewController() -> UIViewController {
        let viewModel = UpcomingMoviesViewModel()
        let moviesViewController = UpcomingMoviesViewController(viewModel: viewModel)
        moviesViewController.title = "Upcoming Movies"

        let navigationViewController = UINavigationController(rootViewController: moviesViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true

        return navigationViewController
    }
}
