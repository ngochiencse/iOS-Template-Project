//
//  RoundedUISampleViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import RoundedUI
import SnapKit

class RoundedUISampleViewController: BaseViewController {
    @IBOutlet weak var roundedButton: RoundedButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var content: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.addSubview(self.content)
        self.content.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    @IBAction func selectedSwitchChanged(_ sender: UISwitch) {
        self.roundedButton.isSelected = sender.isOn
    }

    @IBAction func enabledSwitchChanged(_ sender: UISwitch) {
        self.roundedButton.isEnabled = sender.isOn
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
