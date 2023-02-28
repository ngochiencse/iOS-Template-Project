//
//  ErrorHandler.swift
//  ios_template_project
//
//  Created by Hien Pham on 5/21/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import Foundation

class ErrorHandler: NSObject {
    static let shared: ErrorHandler = ErrorHandler()

    @discardableResult
    func handleCommonError(_ error: Error,
                           autoHandleNoInternetConnection: Bool = true,
                           autoHandleAPIError: Bool = true) -> Error {
        // Handle no internet connection automatically if needed
        if error.isNetworkError == true {
            if autoHandleNoInternetConnection == true {
                NotificationCenter.default.post(name: .AutoHandleNoInternetConnectionError, object: error)
                return APIError.ignore(error)
            } else {
                return error
            }
        }
        // Handle api error automatically if needed
        else if autoHandleAPIError == true {
            NotificationCenter.default.post(name: .AutoHandleAPIError, object: error)
            return APIError.ignore(error)
        } else {
            return error
        }
    }
}
