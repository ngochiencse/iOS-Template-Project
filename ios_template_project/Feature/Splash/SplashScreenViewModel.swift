//
//  SplashScreenViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift

enum SplashScreenNextAction: Int {
    case tutorialScreen = 0
    case loginScreen
    case homeScreen
}

protocol SplashScreenViewModel: class {
    var onFinish: PublishSubject<SplashScreenNextAction> { get }
    func checkLocalData()
}
