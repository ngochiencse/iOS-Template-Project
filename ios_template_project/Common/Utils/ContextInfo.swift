//
//  ContextInfo.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
protocol ContextInfo: NSObjectProtocol {
    var contextInfo: [AnyHashable: Any] {get set}
}

private let key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)

extension NSObject: ContextInfo {
    var contextInfo: [AnyHashable: Any] {
        get {

            if let unwrapped: [AnyHashable: Any] = objc_getAssociatedObject(self, key) as? [AnyHashable: Any] {
                return unwrapped
            } else {
                let result: [AnyHashable: Any] = Dictionary()
                objc_setAssociatedObject(self, key, result, .OBJC_ASSOCIATION_RETAIN)
                return result
            }
        }

        set {
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
