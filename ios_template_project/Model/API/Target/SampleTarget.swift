//
//  SampleTargetr.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/14/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Moya

public enum SampleTarget {
    case articleList(limit: Int, offset: Int)
    case deleteArticle(id: String)
    case login(email: String, password: String)
    case post(title: String, content: String, image: UIImage)
    case updateDeviceToken(_ fcmToken: String)
}

// MARK: - TargetType Protocol Implementation
extension SampleTarget: TargetType {
    public var baseURL: URL {
        let host: String = Environment.shared.configuration(.apiHost)
        let path: String = Environment.shared.configuration(.apiPath)
        let baseURL: URL = URL(string: host + path)!
        return baseURL
    }

    public var path: String {
        switch self {
        case .articleList:
            return "articles"
        case .deleteArticle(let id):
            return "users/\(id)"
        case .login:
            return "login"
        case .post:
            return "post"
        case .updateDeviceToken:
            return "update-token"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .articleList:
            return .get
        case .deleteArticle:
            return .delete
        case .login:
            return .post
        case .post:
            return .post
        case .updateDeviceToken:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case .articleList(limit: let limit, offset: let offset):
            return .requestParameters(parameters: ["limit": limit, "offset": offset], encoding: URLEncoding.default)
        case .deleteArticle:
            return .requestPlain
        case .login(let email, let password):
            return .requestParameters(parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default)
        case .post(let title, let content, let image):
            var formData: [MultipartFormData] = []
            formData.append(MultipartFormData(provider: .data(title.utf8Encoded), name: "title"))
            formData.append(MultipartFormData(provider: .data(content.utf8Encoded), name: "content"))
            let imageData = image.jpegData(compressionQuality: 0.7)!
            formData.append(MultipartFormData(provider: .data(imageData),
                                              name: "image",
                                              fileName: "image.jpeg",
                                              mimeType: "image/jpeg"))
            return .uploadMultipart(formData)
        case .updateDeviceToken(let fcmToken):
            return .requestParameters(parameters: ["token": fcmToken], encoding: JSONEncoding.default)
        }
    }

    public var sampleData: Data {
        switch self {
        case .articleList:
            return dataFromResource(name: "campaign_and_others_info_get_api.php")
        case .deleteArticle:
            return "".utf8Encoded
        case .login:
            return
                """
                    {
                        "access_token":
                            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY\
                3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
                    }
                """.utf8Encoded
        case .post:
            return "".utf8Encoded
        case .updateDeviceToken:
            return "".utf8Encoded
        }
    }

    private func dataFromResource(name: String) -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}

extension SampleTarget: AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}
