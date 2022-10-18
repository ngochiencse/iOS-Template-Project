//
//  TitleLabelCell.swift
//  ios_template_project
//
//  Created by Nguyen truong doanh on 5/5/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import UIKit
import Eureka

open class TitleLabelCell: LabelCellOf<String> {
    @IBOutlet weak var contentDetailLabel: UILabel!
    @IBOutlet weak var topSpaceConstaint: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    open override func update() {
        super.update()
        textLabel?.isHidden = true
        contentDetailLabel.text = textLabel?.text
    }
}

public final class TitleLabelRow: Row<TitleLabelCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<TitleLabelCell>(nibName: "TitleLabelCell", bundle: Bundle.main)
    }
}
