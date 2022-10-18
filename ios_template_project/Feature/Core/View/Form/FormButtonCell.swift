//
//  FormButtonCell.swift
//  ios_template_project
//
//  Created by Nguyen truong doanh on 5/5/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import UIKit
import Eureka
import RoundedUI

class FormButtonCell: ButtonCellOf<String> {
    @IBOutlet weak var button: RoundedButton!
    @IBOutlet weak var topSpaceConstaint: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    override func update() {
        super.update()
        textLabel?.isHidden = true
        button.setTitle(row.title, for: .normal)
    }

    @IBAction func buttonClicked(_ sender: Any) {
        row.didSelect()
    }
}

final class FormButtonRow: Row<FormButtonCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<FormButtonCell>(nibName: "FormButtonCell", bundle: Bundle.main)
    }
}
