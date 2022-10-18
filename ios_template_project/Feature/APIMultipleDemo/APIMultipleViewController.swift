//
//  APIMultipleViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import MBProgressHUD

class APIMultipleViewController: BaseViewController {
    var viewModel: APIMultipleViewModel

    init(viewModel: APIMultipleViewModel = APIMultipleViewModelImpl()) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func operationQueueButtonClicked(_ sender: Any) {
        viewModel.runOperationQueue()
    }

    @IBAction func oneByOneButtonClicked(_ sender: Any) {
        viewModel.runOneByOne()
    }
}
