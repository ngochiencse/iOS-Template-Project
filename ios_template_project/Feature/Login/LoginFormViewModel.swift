//
//  LoginViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/9/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginFormViewModel: AnyObject {
    var basicViewModel: BasicViewModel { get }
    var email: BehaviorRelay<String?> { get set }
    var password: BehaviorRelay<String?> { get set }
    var loginFinish: PublishSubject<Void> { get }
    func login()
}
