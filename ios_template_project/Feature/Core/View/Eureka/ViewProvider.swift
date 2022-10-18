//
//  ViewProvider.swift
//  ios_template_project
//
//  Created by Nguyen truong doanh on 5/5/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import Foundation
import UIKit

public struct ViewProvider<T> where T: UIView {

    /// Nibname of the cell that will be created.
    public private (set) var nibName: String?

    /// Bundle from which to get the nib file.
    public private (set) var bundle: Bundle!

    public init() {}

    public init(nibName: String, bundle: Bundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle
    }

    public func makeView() -> T {
        if let nibName = self.nibName {
            return (bundle.loadNibNamed(nibName, owner: nil, options: nil)!.first as? T)!
        }
        return T()
    }
}
