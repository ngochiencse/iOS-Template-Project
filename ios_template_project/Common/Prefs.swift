//
//  Prefs.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PrefsUserInfo: class {
    func getUserInfo() -> User?
    func saveUserInfo(_ userInfo: User?)
}

protocol PrefsShowTutorial: class {
    func setShowTutorial(showTutorial: Bool)
    func isShowTutorial() -> Bool
}

protocol PrefsAccessToken: class {
    func getAccessToken() -> String?
    func saveAccessToken(_ accessToken: String?)
}

protocol PrefsRefreshToken: class {
    func getRefreshToken() -> String?
    func saveRefreshToken(_ accessToken: String?)
}
