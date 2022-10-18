//
//  ArticleTableCellViewModel.swift
//  ios_template_project
//
//  Created by lephuhao on 23/11/2020.
//  Copyright © 2020 Hien Pham. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleTableCellViewModel {
    var categoryName: String? { get }
    var title: String? { get }
    var body: String? { get }
    var thumbnail: String? { get }
    var defaultImage: UIImage? { get }
    var data: Any? { get }
}
