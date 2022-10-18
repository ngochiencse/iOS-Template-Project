//
//  AlertPresentableView.swift
//  AlertSample
//
//  Created by Isa Aliev on 10.10.2018.
//  Copyright © 2018 IsaAliev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

protocol AlertPresentableView {
    var alertViewModel: AlertPresentableViewModel { get }
}

extension AlertPresentableView where Self: UIViewController {
    func bindToAlerts() {
        bindAlertViewModel(alertViewModel)
    }
}

extension UIViewController {
    @discardableResult
    func bindAlertViewModel(_ alertViewModel: AlertPresentableViewModel) -> Disposable {
        let disposable = alertViewModel.alertModel.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (model: AlertModel?) in
                guard let model = model else {
                    return
                }

                let alert = AlertBuilder.buildAlertController(for: model)
                self?.present(alert, animated: true, completion: nil)
            })
        disposable.disposed(by: rx.disposeBag)
        return disposable
    }

}
