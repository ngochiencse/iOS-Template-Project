//
//  StringUtils.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/14/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
