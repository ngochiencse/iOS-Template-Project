//
//  AppViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 10/26/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseMessaging
import CocoaLumberjack

import Foundation
import RxSwift
import RxCocoa
import Moya

class RootViewModelImpl: NSObject, RootViewModel {
    let basicViewModel: BasicViewModel
    let onAccessTokenExpiredDismiss: PublishSubject<Void> = PublishSubject()
    let prefs: PrefsUserInfo & PrefsAccessToken
    let onShowMaintenace: PublishSubject<Void> = PublishSubject()
    var isAccessTokenExpired: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    init(prefs: PrefsUserInfo & PrefsAccessToken = PrefsImpl.default,
         basicViewModel: BasicViewModel = BasicViewModelImpl()) {
        self.prefs = prefs
        self.basicViewModel = basicViewModel
        super.init()
        setUpObserver()
    }

    func clearLocalData() {
        prefs.saveUserInfo(nil)
        prefs.saveAccessToken(nil)
    }

    func setUpObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccessTokenExpired),
                                               name: .AutoHandleAccessTokenExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAPIError(_:)),
                                               name: .AutoHandleAPIError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoInternetConnectionError(_:)),
                                               name: .AutoHandleNoInternetConnectionError, object: nil)
    }

    @objc func handleAccessTokenExpired() {
        isAccessTokenExpired.accept(true)
    }

    @objc func handleAPIError(_ notification: Notification) {
        guard let error: Error = notification.object as? Error else { return }

        // Don't handle ignore error
        if case APIError.ignore(_) = error {
            return
        }

        let messageError: String?

        if let localizedError: LocalizedAppError = error as? LocalizedAppError,
           let message = localizedError.appErrorDescription {
            messageError = message
        } else {
            messageError = "システムエラーが発生しました。"
        }

        if let unwrapped = messageError {
            let alert = AlertModel(actionModels:
                                    [AlertModel.ActionModel(title: "はい", style: .default, handler: nil)],
                                   title: nil,
                                   message: unwrapped,
                                   prefferedStyle: .alert)
            basicViewModel.alertModel.accept(alert)
        }
    }

    @objc func handleNoInternetConnectionError(_ notification: Notification) {
        let alert = AlertModel(actionModels:
                                [AlertModel.ActionModel(title: "OK", style: .default, handler: nil)],
                               title: nil,
                               message: "通信に失敗しました。\n通信環境の良いところで再度お試しください。",
                               prefferedStyle: .alert)
        basicViewModel.alertModel.accept(alert)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
