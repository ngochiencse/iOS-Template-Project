//
//  APIError.swift
//  ios_template_project
//
//  Created by Hien Pham on 4/7/20.
//  Copyright © 2020 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Moya

protocol LocalizedAppError {
    var appErrorDescription: String? { get }
}

/**
 Error when calling api
 */
enum APIError: Error {
    case ignore(_ error: Error)
    case accessTokenExpired(_ error: Error)
    case serverError(_ detail: APIErrorDetail)
    case parseError
    case systemError
    case jtiError(_ message: String?)
}

struct APIErrorDetail: Error, Codable {
    let code: String
    let message: String?

    var localizedDescription: String {
        return message ?? ""
    }
}

extension APIError: LocalizedAppError {
    var appErrorDescription: String? {
        switch self {
        case .serverError(let detail):
            return detail.appErrorDescription
        case .jtiError(let message):
            return message
        case .systemError:
            return "接続に失敗しました。"
        default:
            return nil
        }
    }
}

extension APIErrorDetail: LocalizedAppError {
    var appErrorDescription: String? {
        message
    }
}

extension MoyaError: LocalizedAppError {
    var appErrorDescription: String? {
        switch self {
        case .underlying(let error, _):
            if let unwrapped = error as? LocalizedAppError {
                return unwrapped.appErrorDescription
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}

struct SimpleError: Error {
    let message: String?
}

extension SimpleError: LocalizedAppError {
    var appErrorDescription: String? {
        return message
    }
}
