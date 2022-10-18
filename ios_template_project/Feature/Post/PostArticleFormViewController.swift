//
//  PostArticleFormViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 7/29/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import RxCocoa
import RxSwift
import NSObject_Rx

class PostArticleFormViewController: FormViewController, BasicViewPresentableView {
    var viewModel: PostArticleFormViewModel
    var basicViewModel: BasicViewModel {
        return viewModel.basicViewModel
    }
    private(set) var binding: Disposable?

    init(viewModel: PostArticleFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section()
            <<< TextRow("title") { row in
                row.title = "Title"
                row.placeholder = "Enter title here"
                row.value = viewModel.title.value
                row.add(rule: RuleRequired(msg: "Title required!"))
            }
            <<< ImageRow("image") { row in
                row.title = "Image"
                row.value = viewModel.image.value
                row.sourceTypes = [.PhotoLibrary]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                row.add(rule: RuleRequired(msg: "Image required!"))
            }
            <<< TextAreaRow("content") { row in
                row.title = "Content"
                row.placeholder = "Enter content here"
                row.value = viewModel.content.value
                row.add(rule: RuleRequired(msg: "Content required!"))
            }

        self.bindToViewModel()
    }

    private func bindToViewModel() {
        Observable.combineLatest(
            viewModel.title.asObservable(),
            viewModel.image.asObservable(),
            viewModel.content.asObservable())
            .subscribe { (_) in
                self.tableView.reloadData()
            }.disposed(by: rx.disposeBag)
    }

    private func unbindFromViewModel() {
        binding?.dispose()
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
        let errors: [ValidationError] = form.validate()
        if let error: ValidationError = errors.first {
            basicViewModel.alertModel.accept(AlertModel(message: error.msg))
            return
        }

        let values = form.values()
        guard
            let title: String = values["title"] as? String,
            let content: String = values["content"] as? String,
            let image: UIImage = values["image"] as? UIImage
        else { return }

        // Silent update
        unbindFromViewModel()
        viewModel.title.accept(title)
        viewModel.content.accept(content)
        viewModel.image.accept(image)
        bindToViewModel()

        viewModel.postArticle()
    }
}
