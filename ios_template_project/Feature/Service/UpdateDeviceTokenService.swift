//
//  UpdateDeviceTokenService.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/10/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UpdateDeviceTokenEvent {
    case loginSuccess
    case receive(_ fcmToken: String)
}

protocol UpdateDeviceTokenServiceDelegate: class {
    func updateDeviceTokenService(_ updateDeviceTokenService: UpdateDeviceTokenService,
                                  didUpdateWithSuccess success: Bool)
}

protocol UpdateDeviceTokenService: class {
    var delegate: UpdateDeviceTokenServiceDelegate? { get set }
    var events: PublishSubject<UpdateDeviceTokenEvent> { get set }
    func updateDeviceToken(_ fcmToken: String)
}
