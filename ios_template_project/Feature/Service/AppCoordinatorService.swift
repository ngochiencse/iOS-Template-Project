//
//  BackgroundService.swift
//  conobieapp
//
//  Created by Hien Pham on 4/17/20.
//  Copyright © 2020 LITALICO Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum AppStatus {
    case startApp
    case active
    case inActive
}

struct PushNotification {
    let createdAt: AppStatus
    let content: [AnyHashable: Any]
}

protocol AppCoordinatorService: class {
    var pushNotification: BehaviorRelay<PushNotification?> { get }

    // Push notification
    func didHandlePushNotification()
    func didStartAppWithPushContent(_ pushContent: [AnyHashable: Any])
    func didReceivePushContent(_ pushContent: [AnyHashable: Any], isAppActive: Bool)
}
