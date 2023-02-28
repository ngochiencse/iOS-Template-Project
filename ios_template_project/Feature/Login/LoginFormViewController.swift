//
//  LoginFormViewController.swift
//  ios_template_project
//
//  Created by Nguyen truong doanh on 5/5/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import SwiftDate

protocol LoginFormViewControllerDelegate: class {
    func loginFormViewControllerDidFinish(_ loginFormViewController: LoginFormViewController)
}

class LoginFormViewController: FormViewController {

    var viewModel: LoginFormViewModel
    var basicViewModel: BasicViewModel {
        return viewModel.basicViewModel
    }
    weak var delegate: LoginFormViewControllerDelegate?
    private(set) var binding: Disposable?
    @IBOutlet private var footer: UIView!

    init(viewModel: LoginFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        setUpForm()
        bindToViewModel()
    }

    private func setUpForm() {
        form +++ Section({ (section) in
            section.footer = {
                var footer = HeaderFooterView<UIView>(.callback({
                    return UIView()
                }))
                footer.height = { 58 }
                return footer
            }()
        })
        <<< TitleLabelRow(nil, { (row) in
            row.title = "ログイン"
        }).cellSetup({ (cell, _) in
            cell.topSpaceConstaint.constant = 12
            cell.bottomSpaceConstraint.constant = 16
        })
        <<< FormEmailRow("email", { row in
            row.title = "メールアドレス"
            row.placeholder = "メールアドレス入力"
            row.add(rule: RuleRequired(msg: "エラー表示はなし"))
            #if DEBUG
            row.value = "hello@world.com.vn"
            #endif
        })
        <<< FormPasswordRow("password", { row in
            row.title = "パスワード"
            row.placeholder = "パスワード入力"
            row.add(rule: RuleRequired(msg: "エラー表示はなし"))
            #if DEBUG
            row.value = "123456"
            #endif
        })
        <<< FormButtonRow(nil, { (row) in
            row.title = "ログイン"
        }).cellSetup({ (cell, _) in
            cell.topSpaceConstaint.constant = 12
            cell.bottomSpaceConstraint.constant = 4
        }).onCellSelection({[weak self] (_, _) in
            self?.submitButtonClicked()
        })
    }

    private func bindToViewModel() {
        viewModel.loginFinish.observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
            self.delegate?.loginFormViewControllerDidFinish(self)
        }).disposed(by: rx.disposeBag)
    }

    @IBAction func submitButtonClicked() {
        let values: [String: Any?] = form.values()
        viewModel.email.accept(values["email"] as? String)
        viewModel.password.accept(values["password"] as? String)
        viewModel.login()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
