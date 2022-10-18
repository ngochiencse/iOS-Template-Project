//
//  FormFieldCell.swift
//  ios_template_project
//
//  Created by Nguyen truong doanh on 5/5/21.
//  Copyright © 2021 Hien Pham. All rights reserved.
//

import UIKit
import Eureka
import SnapKit

public protocol FieldRowHasCustomContentView: class {
    var contentViewProvider: ViewProvider<FormFieldCellContentView>? { get set }
    var maxLength: Int { get set }
    var imageIcon: UIImage? { get set }
}

open class OpenFormFieldCell<T>: _FieldCell<T> where T: Equatable, T: InputTypeInitiable {
    var bsContentView: FormFieldCellContentView?

    var originFont: UIFont?
    var originTextColor: UIColor?
    var maxLength: Int = 0
    var imageIcon: UIImage?

    open override func setup() {
        bsContentView = (row as? FieldRowHasCustomContentView)?.contentViewProvider?.makeView()
        self.maxLength = (row as? FieldRowHasCustomContentView)?.maxLength ?? 0
        imageIcon = (row as? FieldRowHasCustomContentView)?.imageIcon
        if let unwrapped = bsContentView {
            backgroundColor = UIColor.clear
            contentView.backgroundColor = UIColor.clear
            textField.removeFromSuperview()
            contentView.addSubview(unwrapped)
            unwrapped.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            textField = unwrapped.textField
            unwrapped.imvIcon.image = imageIcon
            unwrapped.eyeButton.addTarget(self, action: #selector(eyeButtonClicked), for: .touchUpInside)
            unwrapped.eyeButton.isHidden = true

            originFont = unwrapped.textField.font
            originTextColor = unwrapped.textField.textColor
        }

        super.setup()
    }

    open override func update() {
        super.update()

        titleLabel?.isHidden = true

        bsContentView?.cellTitleLabel.text = row.title
        bsContentView?.cellTitleLabel.textColor = (row.validationErrors.count <= 0) ? .black : .red

        textField.font = originFont
        textField.textColor = originTextColor
        textField.textAlignment = .left

        bsContentView?.errorContainer.isHidden = (row.validationErrors.count <= 0)

        updateEyeButton()

        bsContentView?.errorLabel.text = row.validationErrors.first?.msg
    }

    open override func customConstraints() {}

    @objc func eyeButtonClicked() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        updateEyeButton()
    }

    private func updateEyeButton() {
        let imageName: String = (textField.isSecureTextEntry == true ? "icon24EyeClose" : "icon24EyeOpen")
        bsContentView?.eyeButton.setImage(UIImage(named: imageName), for: .normal)
    }

    open override func textField(_ textField: UITextField,
                                 shouldChangeCharactersIn range: NSRange,
                                 replacementString string: String) -> Bool {
        _ = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        if maxLength == 0 {
            return true
        } else {
            if string.isEmpty {
                return true
            }
            let lastText = string + (textField.text ?? "")
            return !(lastText.count > maxLength)
        }
    }
}

open class FormTextCell: OpenFormFieldCell<String>, CellType {
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.keyboardType = .default
    }
}

open class FormNameCell: OpenFormFieldCell<String>, CellType {
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.keyboardType = .asciiCapable
        if #available(iOS 10, *) {
            textField.textContentType = .name
        }
    }
}

open class FormPhoneCell: OpenFormFieldCell<String>, CellType {
    open override func setup() {
        super.setup()
        textField.keyboardType = .phonePad
        if #available(iOS 10, *) {
            textField.textContentType = .telephoneNumber
        }
    }
}

open class FormEmailCell: OpenFormFieldCell<String>, CellType {
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        if #available(iOS 10, *) {
            textField.textContentType = .emailAddress
        }
    }
}

open class FormPasswordCell: OpenFormFieldCell<String>, CellType {
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        if #available(iOS 11, *) {
            textField.textContentType = .password
        }
        bsContentView?.eyeButton.isHidden = false
    }

    open override func update() {
        super.update()
        textField.clearButtonMode = .never
    }
}

open class FormFieldRow<Cell: CellType>: FieldRow<Cell>,
                                         FieldRowHasCustomContentView where Cell: BaseCell,
                                                                            Cell: TextFieldCell {
    public var contentViewProvider: ViewProvider<FormFieldCellContentView>?
    public var iconImageName: String?
    public var maxLength: Int = .zero
    public var imageIcon: UIImage?
    public required init(tag: String?) {
        super.init(tag: tag)

        contentViewProvider = ViewProvider<FormFieldCellContentView>(nibName: "FormFieldCellContentView",
                                                                     bundle: Bundle.main)
    }
}

extension RowType where Self: BaseRow {
    func setUpCommon() {
        onRowValidationChanged { (cell, row) in
            UIView.performWithoutAnimation {
                cell.formViewController()?.tableView.performBatchUpdates({
                    row.updateCell()
                }, completion: nil)
            }
        }

        validationOptions = .validatesOnDemand
    }
}

final class FormTextRow: FormFieldRow<FormTextCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        setUpCommon()
    }
}

final class FormNameRow: FormFieldRow<FormNameCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        setUpCommon()
    }
}

final class FormPhoneRow: FormFieldRow<FormPhoneCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        setUpCommon()
    }
}

final class FormEmailRow: FormFieldRow<FormEmailCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        setUpCommon()
    }
}

final class FormPasswordRow: FormFieldRow<FormPasswordCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        setUpCommon()
    }
}
