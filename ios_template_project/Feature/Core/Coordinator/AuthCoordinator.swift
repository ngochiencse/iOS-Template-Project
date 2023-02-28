//
//  AuthCoordinator.swift
//  ios_template_project
//
//  Created by Hien Pham on 10/25/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
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
        let viewController: LoginFormViewController = LoginFormViewController(viewModel: LoginFormViewModelImpl())
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
        root.showViewController(navigationController, animated: true)
    }
}

extension AuthCoordinator: LoginFormViewControllerDelegate {
    func loginFormViewControllerDidFinish(_ loginFormViewController: LoginFormViewController) {
        delegate?.authCoordinatorDidFinish(self)
    }
}
