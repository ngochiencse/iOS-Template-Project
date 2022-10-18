//
//  BaseViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BasicViewPresentableView {
    private(set) var basicViewModel: BasicViewModel

    init(basicViewModel: BasicViewModel = BasicViewModelImpl(),
         nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.basicViewModel = basicViewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    init(basicViewModel: BasicViewModel = BasicViewModelImpl()) {
        self.basicViewModel = basicViewModel
        let nibName = String(describing: type(of: self))
        if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
            super.init(nibName: nibName, bundle: nil)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Config navigation bar hidden status for each view controller.
     If true, then each time the view controller appear, navigation bar will be shown,
     else the navigation bar will be hidden.
     */
    var navigationBarHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindToBasicObserve()

        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Update navigation bar hidden status
        self.navigationController?.setNavigationBarHidden(self.navigationBarHidden, animated: animated)
    }
}

extension UIViewController {
    /**
     Conveniently present a view controller with a navigation controller and a dismiss button
     */
    func present(_ viewControllerToPresent: UIViewController,
                 withNavigationController: Bool,
                 animated flag: Bool,
                 completion: (() -> Void)? = nil) {
        if withNavigationController == true {
            viewControllerToPresent.addDismissButton()
            if viewControllerToPresent is BaseViewController {
                let nav: BaseNavigationController = BaseNavigationController(
                    rootViewController: viewControllerToPresent)
                self.present(nav, animated: flag, completion: completion)
            } else {
                self.present(viewControllerToPresent, animated: flag, completion: completion)
            }
        }
    }

    /**
     Override this method to customize when click on dismiss button
     */
    @objc func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func addDismissButton() {
        let image: UIImage = UIImage(named: "btn_close_gray")!
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width + 10 * 2, height: 44))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonClicked(_:)), for: .touchUpInside)
        let barButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
}
