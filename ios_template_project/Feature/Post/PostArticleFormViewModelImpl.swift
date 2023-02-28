//
//  PostArticleFormViewModel.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/23/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class PostArticleFormViewModelImpl: NSObject, PostArticleFormViewModel {
    let basicViewModel: BasicViewModel

    var title: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var content: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let api: Provider<MultiTarget>

    init(basicViewModel: BasicViewModel = BasicViewModelImpl(),
         api: Provider<MultiTarget> =
            ProviderAPIWithAccessToken<MultiTarget>(
                stubClosure: MoyaProvider.delayedStub(0.5))) {
        self.basicViewModel = basicViewModel
        self.api = api
        super.init()
    }

    func postArticle() {
        guard
            let title: String = title.value,
            let content: String = content.value,
            let image: UIImage = image.value
        else { return }

        basicViewModel.progressHUD.showProgressHUD.accept(true)
        api.request(MultiTarget(SampleTarget.post(title: title, content: content, image: image)))
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                switch event {
                case .success:
                    self.basicViewModel.alertModel.accept(AlertModel(message: "Post succeeded"))
                case .error(let error):
                    self.basicViewModel.alertModel.accept(AlertModel(message: error.localizedDescription))
                }
            }
            .disposed(by: rx.disposeBag)
    }
}
