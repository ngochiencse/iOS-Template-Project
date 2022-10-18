//
//  ArticleTableCell.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableCell: UITableViewCell {
    @IBOutlet private weak var test: UILabel!
    @IBOutlet private weak var lbCategoryName: UILabel!
    @IBOutlet private weak var iconPen: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var imageRecommendIcon: UIImageView!
    @IBOutlet private weak var imageNewIcon: UIImageView!
    @IBOutlet private weak var horizantalCategoryConstraint: NSLayoutConstraint!

    var viewModel: ArticleTableCellViewModel? {
        didSet {
            bindData()
        }
    }

    public func bindData() {
        if viewModel?.thumbnail != nil && viewModel?.thumbnail?.count ?? 0 > 0 {
            self.thumbnail.sd_setImage(with: URL(string: viewModel?.thumbnail ?? ""),
                                       placeholderImage: nil, options: SDWebImageOptions.retryFailed)
        } else {
            self.thumbnail.image = viewModel?.defaultImage
        }
        self.lbCategoryName.text = viewModel?.categoryName
        self.titleLabel.text = viewModel?.title
        self.titleLabel.sizeToFit()
        self.bodyLabel.text = viewModel?.body
        self.bodyLabel.sizeToFit()
        self.imageNewIcon.isHidden = false
        self.horizantalCategoryConstraint.constant = 55.0
    }
}
