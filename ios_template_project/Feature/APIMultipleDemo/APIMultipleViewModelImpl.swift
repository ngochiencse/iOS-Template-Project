//
//  APIMultipleView.swift
//  ios_template_project
//
//  Created by Hien Pham on 9/23/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class APIMultipleViewModelImpl: NSObject, APIMultipleViewModel {
    private(set) var basicViewModel: BasicViewModel
    private var queue: OperationQueue = OperationQueue()
    let api: Provider<MultiTarget>

    init(basicViewModel: BasicViewModel = BasicViewModelImpl(),
         api: Provider<MultiTarget> = ProviderAPIWithAccessToken<MultiTarget>()) {
        self.basicViewModel = basicViewModel
        self.api = api
        super.init()
    }

    func runOperationQueue() {
        basicViewModel.progressHUD.showProgressHUD.accept(true)
        let login = APIOperation<Response>(single:
                                            api
                                            .request(MultiTarget(SampleTarget.login(email: "", password: "")))
                                            .filterSuccessfulStatusCodes()
                                            .catchCommonError()
        )
        let getArticle = APIOperation<[ArticleInfo]>(single:
                                                        api
                                                        .request(MultiTarget(
                                                                    SampleTarget.articleList(limit: 30, offset: 0)))
                                                        .filterSuccessfulStatusCodes()
                                                        .map([ArticleInfo].self)
                                                        .catchCommonError()
        )
        let completion = BlockOperation {
            DispatchQueue.main.async {
                self.basicViewModel.progressHUD.showProgressHUD.accept(false)
                self.basicViewModel.alertModel.accept(AlertModel(message: "Success"))
            }
        }
        completion.addDependency(login)
        completion.addDependency(getArticle)
        queue = OperationQueue()
        queue.isSuspended = true
        queue.addOperation(login)
        queue.addOperation(getArticle)
        queue.addOperation(completion)
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = false
    }

    func runOneByOne() {
        basicViewModel.progressHUD.showProgressHUD.accept(true)
        api
            .request(MultiTarget(SampleTarget.login(email: "", password: "")))
            .flatMap {[weak self] (_) -> Single<[ArticleInfo]> in
                guard let self = self else {
                    return Single.error(APIError.systemError)
                }
                return self.api
                    .request(MultiTarget(SampleTarget.articleList(limit: 30, offset: 0)))
                    .filterSuccessfulStatusCodes()
                    .map([ArticleInfo].self)
            }
            .catchCommonError()
            .subscribe({[weak self] (event) in
                guard let self = self else { return }
                switch event {
                case .success:
                    self.basicViewModel.alertModel.accept(AlertModel(message: "Success"))
                case .error:
                    break
                }
                self.basicViewModel.progressHUD.showProgressHUD.accept(false)
            })
            .disposed(by: rx.disposeBag)
    }
}
