//
//  UpdateDeviceTokenServiceImpl.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/10/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class UpdateDeviceTokenServiceImpl: NSObject, UpdateDeviceTokenService {
    weak var delegate: UpdateDeviceTokenServiceDelegate?
    var events: PublishSubject<UpdateDeviceTokenEvent> = PublishSubject()
    let api: Provider<MultiTarget>
    let prefs: PrefsAccessToken
    private(set) var fcmToken: String?

    init(prefs: PrefsAccessToken = PrefsImpl.default,
         api: Provider<MultiTarget> =
            ProviderAPIWithAccessToken<MultiTarget>(
                autoHandleAccessTokenExpired: false,
                autoHandleAPIError: false)) {
        self.prefs = prefs
        self.api = api
        super.init()
        bindToEvents()
    }

    private func bindToEvents() {
        events.subscribe(onNext: { (event: UpdateDeviceTokenEvent) in
            switch event {
            case .receive(let fcmToken):
                self.fcmToken = fcmToken
            case .loginSuccess:
                break
            }

            if let fcmToken = self.fcmToken, self.prefs.getAccessToken() != nil {
                self.updateDeviceToken(fcmToken)
            }
        }).disposed(by: rx.disposeBag)
    }

    func updateDeviceToken(_ fcmToken: String) {
        api.request(MultiTarget(SampleTarget.updateDeviceToken(fcmToken))).subscribe {[weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .success:
                self.delegate?.updateDeviceTokenService(self, didUpdateWithSuccess: true)
            case .error:
                self.delegate?.updateDeviceTokenService(self, didUpdateWithSuccess: false)
            }
        }.disposed(by: rx.disposeBag)
    }
}
