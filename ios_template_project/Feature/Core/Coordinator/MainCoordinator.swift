//
//  MainCoordinator.swift
//  ios_template_project
//
//  Created by Hien Pham on 10/25/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    let root: RootViewController
    let navigationController: BaseNavigationController = BaseNavigationController()
    init(root: RootViewController) {
        self.root = root
        super.init()
    }

    func start() {
        let viewController: MainTabbarContainerController = MainTabbarContainerController()
        if let articleViewController: ArticleViewController = viewController.content.viewControllers
            .first(where: { (ele: UIViewController) -> Bool in
                return ele is ArticleViewController
            }) as? ArticleViewController {
            articleViewController.delegate = self
        }
        navigationController.pushViewController(viewController, animated: false)
        root.showViewController(navigationController, animated: true)
    }
}

extension MainCoordinator: ArticleViewControllerDelegate {
    func articleViewController(_ articleViewController: ArticleViewController, didSelect article: ArticleInfo) {
        if let urlString: String = article.url,
           let viewController: WebViewController = WebViewController(urlString: urlString) {
            viewController.title = "Web View"
            viewController.bottomToolBarHidden = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
