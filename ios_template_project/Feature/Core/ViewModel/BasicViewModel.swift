//
//  BasicViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Moya

protocol BasicViewModel: AlertPresentableViewModel, LoadingIndicatorViewModel {
    var progressHUD: ProgressHUDViewModel { get }
}

protocol BasicViewPresentableView: AlertPresentableView, LoadingIndicatorPresentableView {
    var basicViewModel: BasicViewModel { get }
}
