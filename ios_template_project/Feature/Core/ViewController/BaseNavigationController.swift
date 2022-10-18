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
        self.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.navigationBar.layer.shadowOpacity = 1

        // Custom back button
        let image: UIImage? = UIImage(named: "btn_back")
        self.navigationBar.backIndicatorImage = image?.withRenderingMode(.alwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
        let barAppearance: UIBarButtonItem =
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [type(of: self)])
        barAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -3), for: .default)
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
