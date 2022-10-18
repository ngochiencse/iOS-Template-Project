//
//  AppViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RootViewModel: AnyObject {
    var basicViewModel: BasicViewModel { get }
    var prefs: PrefsUserInfo & PrefsAccessToken { get }
    var isAccessTokenExpired: BehaviorRelay<Bool> { get }
    func clearLocalData()
}
