//
//  ArticleTableCellViewModelImpl.swift
//  ios_template_project
//
//  Created by lephuhao on 23/11/2020.
//  Copyright © 2020 Hien Pham. All rights reserved.
//

import Foundation
import UIKit

class ArticleTableCellViewModelImpl: NSObject, ArticleTableCellViewModel {
    let defaultImage: UIImage?
    let categoryName: String?
    let title: String?
    let body: String?
    let thumbnail: String?
    let data: Any?

    init(categoryName: String?,
         title: String?,
         body: String?,
         thumbnail: String?,
         defaultImage: UIImage?,
         data: Any?) {
        self.categoryName = categoryName
        self.title = title
        self.body = body
        self.thumbnail = thumbnail
        self.defaultImage = defaultImage
        self.data = data
    }
}
