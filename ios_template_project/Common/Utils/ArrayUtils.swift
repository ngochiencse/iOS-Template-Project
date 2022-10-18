//
//  ArrayUtils.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: JSON generate
extension Array {
    public func bv_jsonString(prettyPrint: Bool = true) -> String {
        do {
            let jsonData: Data = try JSONSerialization.data(
                withJSONObject: self,
                options: (prettyPrint ?
                            JSONSerialization.WritingOptions.prettyPrinted :
                            JSONSerialization.WritingOptions.init(rawValue: 0)
                )
            )
            let string: String = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            return string
        } catch {
            DDLogError("bv_jsonStringWithPrettyPrint: error: \(String(describing: error))")
            return ""
        }
    }
}
