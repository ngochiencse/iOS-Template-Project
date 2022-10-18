//
//  LoginViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import RxSwift
import NSObject_Rx
import RxBiBinding

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidFinish(_ loginViewController: LoginViewController)
}

class LoginViewController: BaseViewController {
    weak var delegate: LoginViewControllerDelegate?
    private let content: LoginFormViewController

    init(viewModel: LoginFormViewModel = LoginFormViewModelImpl()) {
        content = LoginFormViewController(viewModel: viewModel)
        super.init(basicViewModel: viewModel.basicViewModel)
        content.delegate = self
    }

    init(viewModel: LoginFormViewModel = LoginFormViewModelImpl(),
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        content = LoginFormViewController(viewModel: viewModel)
        super.init(basicViewModel: viewModel.basicViewModel, nibName: nibNameOrNil, bundle: nibBundleOrNil)
        content.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarHidden = true

        view.addSubview(content.view)
        content.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        content.willMove(toParent: self)
        addChild(content)
        content.didMove(toParent: self)
    }
}

extension LoginViewController: LoginFormViewControllerDelegate {
    func loginFormViewControllerDidFinish(_ loginFormViewController: LoginFormViewController) {
        delegate?.loginViewControllerDidFinish(self)
    }
}
