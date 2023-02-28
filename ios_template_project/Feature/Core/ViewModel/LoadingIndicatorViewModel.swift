//
//  LoadingIndicatorViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxCocoa
import MBProgressHUD

protocol LoadingIndicatorViewModel {
    var showIndicator: BehaviorRelay<Bool> { get set }
}

protocol LoadingIndicatorPresentableView {
    var loadingIndicatorViewModel: LoadingIndicatorViewModel { get }
}

protocol Loading where Self: UIView {
    var activityIndicator: UIActivityIndicatorView { get }
}
