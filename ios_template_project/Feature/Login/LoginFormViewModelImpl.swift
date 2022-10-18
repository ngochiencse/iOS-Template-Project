//
//  LoginViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/20/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import RxSwift
import RxCocoa
import NSObject_Rx

typealias PrefsLogin = PrefsAccessToken & PrefsUserInfo

class LoginFormViewModelImpl: NSObject, LoginFormViewModel {
    private(set) var basicViewModel: BasicViewModel
    var email: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let exitEditing: PublishSubject<Void> = PublishSubject()
    let prefs: PrefsLogin
    let loginFinish: PublishSubject<Void> = PublishSubject()

    init(basicViewModel: BasicViewModel = BasicViewModelImpl(), prefs: PrefsLogin = PrefsImpl.default) {
        self.basicViewModel = basicViewModel
        self.prefs = prefs
        super.init()
    }

    func login() {
        let emailClean: String = email.value?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) ?? ""
        if emailClean.count <= 0 {
            basicViewModel.alertModel.accept(AlertModel(message: "ログインIDもしくはパスワードが異なっています。"))
            return
        }

        let passwordClean: String = password.value ?? ""
        if passwordClean.count <= 0 {
            basicViewModel.alertModel.accept(AlertModel(message: "ログインIDもしくはパスワードが異なっています。"))
            return
        }

        NotificationCenter.default.post(name: .LoginSuccess, object: nil, userInfo: nil)
        self.loginFinish.onNext(())
    }
}
