//
//  AuthCoordinator.swift
//  ios_template_project
//
//  Created by Hien Pham on 10/25/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate: class {
    func authCoordinatorDidFinish(_ authCoordinator: AuthCoordinator)
}

class AuthCoordinator: NSObject, Coordinator {
    let root: RootViewController
    let navigationController: BaseNavigationController = BaseNavigationController()
    weak var delegate: AuthCoordinatorDelegate?
    init(root: RootViewController) {
        self.root = root
        super.init()
    }

    func start() {
        let viewController: LoginViewController = LoginViewController()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
        root.showViewController(navigationController, animated: true)
    }
}

extension AuthCoordinator: LoginViewControllerDelegate {
    func loginViewControllerDidFinish(_ loginViewController: LoginViewController) {
        delegate?.authCoordinatorDidFinish(self)
    }
}
