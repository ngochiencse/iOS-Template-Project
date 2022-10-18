//
//  UrlDef.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation

enum WebviewUrlDef: String, CaseIterable {
    case terms = "termsofservice.html"
    case policies = "privacy.html"
    case resetPassword = "resetPassword"

    func urlString() -> String {
        let host: String = Environment.shared.configuration(.apiHost)
        let urlString: String = host + self.rawValue
        return urlString
    }
}
