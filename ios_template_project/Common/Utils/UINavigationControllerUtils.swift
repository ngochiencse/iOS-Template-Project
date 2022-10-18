//
//  UINavigationControllerUtils.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    static func topMostNavigationController() -> UINavigationController? {
        var topNavigationController: UINavigationController?
        var topMostViewController = UIViewController.topMostController()
        while topMostViewController != nil && topMostViewController!.isKind(of: UINavigationController.self) == false {
            topMostViewController = topMostViewController?.presentingViewController
        }
        topNavigationController = topMostViewController as? UINavigationController
        return topNavigationController
    }

    func popToClass<T>(_ classP: T.Type, animated: Bool) {
        if let controller = viewControllers.first(where: { (ele) -> Bool in
            ele is T
        }) {
            popToViewController(controller, animated: animated)
        }
    }
}
