//
//  PostArticleFormViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol PostArticleFormViewModel {
    var basicViewModel: BasicViewModel { get }

    var title: BehaviorRelay<String?> { get set }
    var content: BehaviorRelay<String?> { get set }
    var image: BehaviorRelay<UIImage?> { get set }

    func postArticle()
}
