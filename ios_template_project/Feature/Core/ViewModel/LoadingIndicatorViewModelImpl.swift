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
    func bindToLoadingIndicator() -> [Disposable] {
        view.bindLoadingIndicator(loadingIndicatorViewModel)
    }
}

extension LoadingIndicatorPresentableView where Self: UIView {
    @discardableResult
    func bindToLoadingIndicator() -> [Disposable] {
        return bindLoadingIndicator(loadingIndicatorViewModel)
    }
}

extension UIView {
    @discardableResult
    func bindLoadingIndicator(_ loadingIndicatorViewModel: LoadingIndicatorViewModel) -> [Disposable] {
        var disposables: [Disposable] = []

        let progressHUDDisposable = loadingIndicatorViewModel.showProgressHUD
            .observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] (show: Bool) in
                if show == true {
                    if let progressHUD = self?.progressHUD {
                        self?.addSubview(progressHUD)
                    }
                    self?.progressHUD.show(animated: true)
                } else {
                    self?.progressHUD.hide(animated: true)
                }
            })
        progressHUDDisposable.disposed(by: rx.disposeBag)
        disposables.append(progressHUDDisposable)

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
        disposables.append(indicatorDisposable)

        return disposables
    }
}

private struct AssociatedKeys {
    static var activityIndicator: UInt8 = 0
    static var progressHUD: UInt8 = 1
}

extension UIView: Loading {
    var progressHUD: MBProgressHUD {
        let hud: MBProgressHUD
        if let value = objc_getAssociatedObject(self, &AssociatedKeys.progressHUD) as? MBProgressHUD {
            hud = value
        } else {
            hud = MBProgressHUD(view: self)
            objc_setAssociatedObject(self, &AssociatedKeys.progressHUD, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return hud
    }

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
    var showProgressHUD: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showIndicator: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}
