//
//  BackgroundServiceImpl.swift
//  conobieapp
//
//  Created by Hien Pham on 4/17/20.
//  Copyright © 2020 LITALICO Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AppCoordinatorServiceImpl: NSObject, AppCoordinatorService {
    var pushNotification: BehaviorRelay<PushNotification?> = BehaviorRelay(value: nil)

    func didHandlePushNotification() {
        pushNotification.accept(nil)
    }

    func didStartAppWithPushContent(_ pushContent: [AnyHashable: Any]) {
        pushNotification.accept(PushNotification(createdAt: .startApp, content: pushContent))
    }

    func didReceivePushContent(_ pushContent: [AnyHashable: Any], isAppActive: Bool) {
        let createdAt: AppStatus = (isAppActive == true ? AppStatus.active: AppStatus.inActive)
        pushNotification.accept(PushNotification(createdAt: createdAt, content: pushContent))
    }
}
