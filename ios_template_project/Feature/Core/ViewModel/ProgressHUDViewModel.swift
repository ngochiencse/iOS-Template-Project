//
//  ProgressHUDViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 5/27/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import Foundation
import RxCocoa
import MBProgressHUD

protocol ProgressHUDViewModel {
    var showProgressHUD: BehaviorRelay<Bool> { get }
}

protocol ProgressHUDPresentableView {
    var progressHUDViewModel: ProgressHUDViewModel { get }
}

protocol ProgressHUDGetter where Self: UIView {
    var progressHUD: MBProgressHUD { get }
}
