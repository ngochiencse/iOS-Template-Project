//
//  HandleAPIErrorPlugin.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/13/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Moya
import CocoaLumberjack

struct APIErrorProcessPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case let .success(moyaResponse):
            return .success(moyaResponse)
        case let .failure(error):
            DDLogError("APIErrorProcess on error: \(String(describing: error))")
            return .failure(processError(error))
        }
    }

    func processError(_ error: MoyaError) -> MoyaError {
        do {
            if let detail = try error.response?.map(APIErrorDetail.self,
                                                    atKeyPath: "error",
                                                    using: JSONDecoder(),
                                                    failsOnEmptyData: true) {
                DDLogError("Error content: \(String(describing: detail))")
                return MoyaError.underlying(APIError.serverError(detail), error.response)
            } else {
                return error
            }
        } catch let parseError {
            DDLogError("Parse error json failed: \(String(describing: parseError))")
            if let string = try? error.response?.mapString() {
                DDLogError("Error content: \(string)")
            }
        }
        return error
    }
}
