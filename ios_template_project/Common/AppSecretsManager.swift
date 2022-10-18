//
//  AppSecretsManager.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import CocoaLumberjack

/**
 App secret's manager, mainly store secrets coresponding to development environment
 */
class AppSecretsManager {
    static let shared: AppSecretsManager = AppSecretsManager()

    private(set) var environment: Environment
    private(set) var content: AppSecrets

    init(environment: Environment = .shared) {
        self.environment = environment
        let type: EnvironmentType = self.environment.environmentType
        switch type {
        case .staging:
            content = AppSecretsStaging()
        case .product:
            content = AppSecretsProduct()
        }
    }

    func logAppSecretInfos() {
        var string: String = ""
        var infos: [String: String] = Dictionary()
        infos["secretKey"] = self.content.secretKey
        for key: String in infos.keys {
            if let value: String = infos[key] {
                let lineString: String = key + ": " + value
                string += "\n" + lineString
            }
        }
        DDLogDebug("App secret init with following values: \(string)")
    }
}

/**
 Define app secret keys
 */
protocol AppSecrets {
    var secretKey: String { get }

    // TODO: Define more app secret key here
}

/**
 Value specification for app secret for staging development environment
 */
private class AppSecretsStaging: AppSecrets {
    let secretKey: String = "9667048833"

    // TODO: Specify more app secret value here
}

/**
 Value specification for app secret for product development environment
 */
private class AppSecretsProduct: AppSecrets {
    let secretKey: String = "1669514755"

    // TODO: Specify more app secret value here
}
