//
//  MainTabbarController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import BraveTabbarController
import SnapKit
import Moya

class MainTabbarContainerController: BaseViewController {
    let content: MainTabbarController = MainTabbarController(
        nibName: String(describing: MainTabbarController.self),
        bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        content.delegate = self
        view.addSubview(content.view)
        content.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        content.willMove(toParent: self)
        addChild(content)
        content.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshDisplayMainTabbarController()
    }

    fileprivate func refreshDisplayMainTabbarController() {
        let selectedViewController: UIViewController = self.content.selectedViewController
        self.title = selectedViewController.title
        self.navigationItem.titleView = selectedViewController.navigationItem.titleView
        self.navigationItem.leftBarButtonItems = selectedViewController.navigationItem.leftBarButtonItems
        self.navigationItem.rightBarButtonItems = selectedViewController.navigationItem.rightBarButtonItems
    }
}

extension MainTabbarContainerController: BraveTabbarControllerDelegate {
    func tabBarController(_ tabBarController: BraveTabbarController, didSelectAtIndex selectedIndex: Int) {
        self.refreshDisplayMainTabbarController()
    }
}

class MainTabbarController: BraveTabbarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        var viewControllers: [UIViewController] = Array()
        for index in 0...5 {
            var viewController: BaseViewController
            switch index {
            case 0:
                viewController = ArticleViewController()
                viewController.title = "API Sample"
            case 1:
                viewController = RoundedUISampleViewController()
                viewController.title = "RoundedUI Sample"
            case 2:
                viewController = PostArticleViewController()
                viewController.title = "Post Sample"
            case 3:
                viewController = APIMultipleViewController()
                viewController.title = "API Multiple Demo"
            default:
                viewController = BaseViewController()
                viewController.view.backgroundColor =
                    UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                            green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                            blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: 1)
                viewController.title = String(format: "Tab %d", index + 1)
            }
            viewControllers.append(viewController)
        }
        self.viewControllers = viewControllers
        self.title = "カレンダー"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
