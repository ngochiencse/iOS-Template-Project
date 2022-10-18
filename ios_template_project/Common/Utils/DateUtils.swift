//
//  DateUtils.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
extension Date {
    func string(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let string: String = formatter.string(from: self)
        return string
    }

    init?(string: String, format: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date: Date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
}
