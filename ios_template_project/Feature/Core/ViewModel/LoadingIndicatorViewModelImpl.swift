//
//  LoadingViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MBProgressHUD
import SnapKit
import NSObject_Rx

extension LoadingIndicatorPresentableView where Self: UIViewController {
    @discardableResult
    func bindToLoadingIndicator() -> Disposable {
        view.bindLoadingIndicator(loadingIndicatorViewModel)
    }
}

extension LoadingIndicatorPresentableView where Self: UIView {
    @discardableResult
    func bindToLoadingIndicator() -> Disposable {
        return bindLoadingIndicator(loadingIndicatorViewModel)
    }
}

extension UIView {
    @discardableResult
    func bindLoadingIndicator(_ loadingIndicatorViewModel: LoadingIndicatorViewModel) -> Disposable {
        let indicatorDisposable = loadingIndicatorViewModel.showIndicator
            .observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] (show: Bool) in
                if show == true {
                    if let activityIndicator = self?.activityIndicator {
                        self?.addSubview(activityIndicator)
                    }
                    self?.activityIndicator.snp.makeConstraints({ (make) in
                        make.center.equalToSuperview()
                    })
                    UIView.performWithoutAnimation {
                        self?.layoutIfNeeded()
                    }
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            })
        indicatorDisposable.disposed(by: rx.disposeBag)

        return indicatorDisposable
    }
}

private struct AssociatedKeys {
    static var activityIndicator: UInt8 = 0
}

extension UIView: Loading {
    var activityIndicator: UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView
        if let value = objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView {
            indicator = value
        } else {
            indicator = UIActivityIndicatorView()
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, indicator,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return indicator
    }
}

class LoadingIndicatorViewModelImpl: LoadingIndicatorViewModel {
    var showIndicator: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}
