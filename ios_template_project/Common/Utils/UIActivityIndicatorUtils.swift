//
//  UIActivityIndicatorUtils.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    static func showAdded(to view: UIView) -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.style = .gray
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return indicator
    }
}
