//
//  Prefs.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//
import Foundation
import RxSwift
import CocoaLumberjack

class PrefsImpl: NSObject {
    static let `default`: PrefsImpl = PrefsImpl()
    let defaults: UserDefaults
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    private func saveCodableCustomObject<T: Encodable>(object: T?, key: String) {
        if let unwrapped = object {
            do {
                let data = try JSONEncoder().encode(unwrapped)
                defaults.set(data, forKey: key)
            } catch {
                DDLogError("Save Prefs with type \(String(describing: type(of: object))) failed.")
            }
        } else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }

    private func loadCodableCustomObjectWithKey<T: Decodable>(key: String, class: T.Type) -> T? {
        if let data = defaults.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                DDLogError("Retrieve \(String(describing: T.self)) from Prefs failed.")
                return nil
            }
        }
        return nil
    }
}

extension PrefsImpl: PrefsUserInfo {
    func getUserInfo() -> User? {
        let userInfo: User? = loadCodableCustomObjectWithKey(key: "user", class: User.self)
        return userInfo
    }

    func saveUserInfo(_ user: User?) {
        saveCodableCustomObject(object: user, key: "user")
    }
}

extension PrefsImpl: PrefsShowTutorial {
    func setShowTutorial(showTutorial: Bool) {
        defaults.set(showTutorial, forKey: "showTutorial")
        defaults.synchronize()
    }

    func isShowTutorial() -> Bool {
        var showTutorial: Bool
        if let boolObject = defaults.object(forKey: "showTutorial") {
            showTutorial = boolObject as? Bool ?? true
        } else {
            showTutorial = false
        }
        return showTutorial
    }
}

extension PrefsImpl: PrefsAccessToken {
    func getAccessToken() -> String? {
        return defaults.string(forKey: "accessToken")
    }

    func saveAccessToken(_ accessToken: String?) {
        if let unwrapped = accessToken {
            defaults.set(unwrapped, forKey: "accessToken")
        } else {
            defaults.removeObject(forKey: "accessToken")
        }
        defaults.synchronize()
    }
}

extension PrefsImpl: PrefsRefreshToken {
    func getRefreshToken() -> String? {
        return defaults.string(forKey: "refreshToken")
    }

    func saveRefreshToken(_ refreshToken: String?) {
        if let unwrapped = refreshToken {
            defaults.set(unwrapped, forKey: "refreshToken")
        } else {
            defaults.removeObject(forKey: "refreshToken")
        }
        defaults.synchronize()
    }
}
