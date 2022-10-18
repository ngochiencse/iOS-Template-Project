//
//  DefaultAlamofireManager.swift
//  ios_template_project
//
//  Created by Hien Pham on 3/4/20.
//  Copyright © 2020 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Session {
    static let shared: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
