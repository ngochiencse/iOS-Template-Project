//
//  AlertBuilder.swift
//  BestLikes
//
//  Created by Isa Aliev on 13.08.2018.
//  Copyright © 2018 Isa Aliev. All rights reserved.
//

import UIKit

class AlertBuilder {
    static func buildAlertController(for model: AlertModel) -> UIAlertController {
        let controller = UIAlertController(title: model.title,
                                           message: model.message,
                                           preferredStyle: model.prefferedStyle)
        model.actionModels.forEach({ controller.addAction(UIAlertAction(title: $0.title,
                                                                        style: $0.style,
                                                                        handler: $0.handler)) })

        return controller
    }
}
