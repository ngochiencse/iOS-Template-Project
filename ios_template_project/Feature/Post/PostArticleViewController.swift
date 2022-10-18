//
//  PostArticleViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 7/29/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import SnapKit

class PostArticleViewController: BaseViewController {
    private let content: PostArticleFormViewController

    init(viewModel: PostArticleFormViewModel = PostArticleFormViewModelImpl()) {
        content = PostArticleFormViewController(viewModel: viewModel)
        super.init(basicViewModel: viewModel.basicViewModel)
    }

    init(viewModel: PostArticleFormViewModel = PostArticleFormViewModelImpl(),
         nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        content = PostArticleFormViewController(viewModel: viewModel)
        super.init(basicViewModel: viewModel.basicViewModel, nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(content.view)
        content.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        content.willMove(toParent: self)
        addChild(content)
        content.didMove(toParent: self)
    }
}
