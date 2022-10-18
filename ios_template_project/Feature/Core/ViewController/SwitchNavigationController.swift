//
//  SwitchNavigationController.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/10/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

/**
 Basically this is a container which will switch and display application content.
 */
class SwitchNavigationController: UIViewController {
    /**
     Content view controller
     */
    private(set) var rootViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /**
     Show view controller as the content.

     Manually trigger callback because callbacks are not automatically called when
     add as child view controlle and the container has already loaded view
     */
    func showViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        if let rootViewController = self.rootViewController {
            self.rootViewController = viewController

            rootViewController.willMove(toParent: nil)

            // Handle display new view controller
            self.view.insertSubview(viewController.view, at: 0)
            viewController.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
            }

            // Animation
            self.setNeedsStatusBarAppearanceUpdate()

            if animated == true {
                UIView.animate(withDuration: 0.55, delay: 0,
                               options: [.transitionCrossDissolve, .curveEaseOut],
                               animations: {
                                rootViewController.view.alpha = 0
                               }, completion: {[weak self] (_) in
                                self?.swap(oldViewController: rootViewController,
                                           newViewController: viewController,
                                           animated: animated)
                               })
            } else {
                self.swap(oldViewController: rootViewController, newViewController: viewController, animated: animated)
            }
        } else {
            setNeedsStatusBarAppearanceUpdate()

            rootViewController = viewController
            view.addSubview(viewController.view)
            viewController.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            viewController.didMove(toParent: self)
        }
    }

    private func swap(oldViewController: UIViewController, newViewController: UIViewController, animated: Bool) {
        newViewController.didMove(toParent: self)

        // Remove old view controller
        oldViewController.removeFromParent()
        oldViewController.didMove(toParent: nil)
        oldViewController.view.removeFromSuperview()
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.rootViewController
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.rootViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return self.rootViewController
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.rootViewController
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return rootViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var shouldAutorotate: Bool {
        return rootViewController?.shouldAutorotate ?? false
    }
}
