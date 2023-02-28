//
//  ProgressHUDViewModelImpl.swift
//  ios_template_project
//
//  Created by Hien Pham on 5/27/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import NSObject_Rx
import MBProgressHUD

extension ProgressHUDPresentableView where Self: UIViewController {
    @discardableResult
    func bindToProgressHUD() -> Disposable {
        view.bindProgressHUD(progressHUDViewModel)
    }
}

extension ProgressHUDPresentableView where Self: UIView {
    @discardableResult
    func bindToProgressHUD() -> Disposable {
        return bindProgressHUD(progressHUDViewModel)
    }
}

extension UIView {
    @discardableResult
    func bindProgressHUD(_ progressHUDViewModel: ProgressHUDViewModel) -> Disposable {
        let disposable = progressHUDViewModel.showProgressHUD
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (showProgressHUD) in
                guard let self = self else { return }
                if showProgressHUD == true {
                    self.addSubview(self.progressHUD)
                    self.progressHUD.show(animated: true)
                } else {
                    self.progressHUD.hide(animated: true)
                }
            })
        disposable.disposed(by: rx.disposeBag)
        return disposable
    }
}

private struct AssociatedKeys {
    static var progressHUD: UInt8 = 0
}

extension UIView: ProgressHUDGetter {
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
}

class ProgressHUDViewModelImpl: NSObject, ProgressHUDViewModel {
    static let shared: ProgressHUDViewModelImpl = ProgressHUDViewModelImpl()
    let showProgressHUD: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}
