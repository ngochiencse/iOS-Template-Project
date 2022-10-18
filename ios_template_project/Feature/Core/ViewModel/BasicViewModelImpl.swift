//
//  BasicViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxCocoa
import Moya

extension BasicViewPresentableView where Self: UIViewController {
    var alertViewModel: AlertPresentableViewModel {
        return basicViewModel
    }

    var loadingIndicatorViewModel: LoadingIndicatorViewModel {
        return basicViewModel
    }

    func bindToBasicObserve() {
        bindToAlerts()
        bindToLoadingIndicator()
    }
}

class BasicViewModelImpl: BasicViewModel {
    var alertModel: BehaviorRelay<AlertModel?> = BehaviorRelay(value: nil)
    var showProgressHUD: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showIndicator: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}
