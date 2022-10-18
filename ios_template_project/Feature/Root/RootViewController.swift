//
//  RootContainerViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol RootViewControllerDelegate: class {
    func rootViewControllerOnLogoutEvent(_ rootViewController: RootViewController?)
}

extension Notification.Name {
    static let LogOut: Notification.Name = Notification.Name("LogOut")
}

/**
 Root view controller of an application.

 Basically this is a container which will switch and display application content.
 */
class RootViewController: SwitchNavigationController, AlertPresentableView, LoadingIndicatorPresentableView {
    weak var delegate: RootViewControllerDelegate?

    var alertViewModel: AlertPresentableViewModel {
        return viewModel.basicViewModel
    }

    var loadingIndicatorViewModel: LoadingIndicatorViewModel {
        return viewModel.basicViewModel
    }

    let viewModel: RootViewModel

    init(viewModel: RootViewModel = RootViewModelImpl(prefs: PrefsImpl.default)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToAlertsTop()
        view.bindLoadingIndicator(loadingIndicatorViewModel)
        setUpObserver()
    }

    /**
     This binding is not like normal bind which has been implemented in AlertPresentableView.
     It'll present an alert on top most controller instead of current view controller.
     */
    func bindToAlertsTop() {
        viewModel.isAccessTokenExpired.distinctUntilChanged().observeOn(MainScheduler.instance)
            .filter({ (value: Bool) -> Bool in
                return (value == true)
            }).subscribe(onNext: {[weak self] (_: Bool) in
                self?.viewModel.clearLocalData()
                let alert = UIAlertController(title: nil, message: "Access token expired", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    // Log out using coordinator
                    self?.delegate?.rootViewControllerOnLogoutEvent(self)
                }))

                let topController: UIViewController? = self?.topMostController()

                // Priority of access token expired alert will be highest, so other alert will be dismissed.
                if let _: UIAlertController = topController?.presentedViewController as? UIAlertController {
                    topController?.dismiss(animated: true, completion: {
                        topController?.present(alert, animated: true, completion: nil)
                    })
                } else {
                    topController?.present(alert, animated: true, completion: nil)
                }
            }).disposed(by: rx.disposeBag)

        alertViewModel.alertModel.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (model: AlertModel?) in
                guard let model = model else {
                    return
                }

                let alert = AlertBuilder.buildAlertController(for: model)
                let topController: UIViewController? = self?.topMostController()
                topController?.present(alert, animated: true, completion: nil)
            }).disposed(by: rx.disposeBag)
    }

    func topMostController() -> UIViewController? {
        var topMostController: UIViewController? = self
        while topMostController?.presentedViewController != nil {
            if topMostController?.presentedViewController is UIAlertController {
                break
            } else {
                topMostController = topMostController?.presentedViewController
            }
        }
        return topMostController
    }

    private func setUpObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(logOut), name: .LogOut, object: nil)
    }

    @objc func logOut() {
        viewModel.clearLocalData()
        delegate?.rootViewControllerOnLogoutEvent(self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
