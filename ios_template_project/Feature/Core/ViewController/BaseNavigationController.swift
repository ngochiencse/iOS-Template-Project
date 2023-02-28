//
//  BaseNavigationController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }

    fileprivate func setUp() {
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()

            // Custom navigation bar background
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()

            // Custom navigation bar title
            let titleTextColor: UIColor = UIColor(red: 120/255.0, green: 132/255.0, blue: 158/255.0, alpha: 1.0)
            appearance.titleTextAttributes = [
                .foregroundColor: titleTextColor,
                .font: UIFont.systemFont(ofSize: 20)
            ]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance

            // Custom back button
            let image: UIImage? = UIImage(named: "btn_back")
            appearance.setBackIndicatorImage(image?.withRenderingMode(.alwaysOriginal),
                                             transitionMaskImage: image?.withRenderingMode(.alwaysOriginal))
            let barAppearance: UIBarButtonItem =
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [type(of: self)])
            barAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -3), for: .default)
        } else {
            // Custom navigation bar title
            let titleTextColor: UIColor = UIColor(red: 120/255.0, green: 132/255.0, blue: 158/255.0, alpha: 1.0)
            self.navigationBar.titleTextAttributes = [
                .foregroundColor: titleTextColor,
                .font: UIFont.systemFont(ofSize: 20)
            ]

            // Custom navigation bar background
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.barTintColor = .white
            self.navigationBar.isTranslucent = false

            // Custom back button
            let image: UIImage? = UIImage(named: "btn_back")
            self.navigationBar.backIndicatorImage = image?.withRenderingMode(.alwaysOriginal)
            self.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
            let barAppearance: UIBarButtonItem =
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [type(of: self)])
            barAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -3), for: .default)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
