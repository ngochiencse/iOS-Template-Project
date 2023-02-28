//
//  ArticleViewModelMock.swift
//  ios_template_project
//
//  Created by lephuhao on 24/11/2020.
//  Copyright © 2020 Hien Pham. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class ArticleViewModelMock: NSObject, ArticleViewModel {
    var cellViewModels: BehaviorRelay<[ArticleTableCellViewModel]> = BehaviorRelay(value: [])
    private(set) var basicViewModel: BasicViewModel
    private(set) var articles: BehaviorRelay<[Any]> = BehaviorRelay(value: [])
    private(set) var showsInfiniteScrolling: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let endLoadingAnimation: PublishSubject<Void> = PublishSubject()
    let api: Provider<MultiTarget>
    private var isLoading: Bool = false
    let limit: Int = 20

    var count = 3

    init(basicViewModel: BasicViewModel = BasicViewModelImpl(),
         api: Provider<MultiTarget> = ProviderAPIWithAccessToken<MultiTarget>()) {
        self.basicViewModel = basicViewModel
        self.api = api
        super.init()
        bindToEvents()
    }

    func bindToEvents() {
        articles.map {articles in
            articles.map {_ in
                return ArticleTableCellViewModelImpl(categoryName: "注目の情報",
                                                     title:
                                                        """
                                                         無料アプリ「まいにちのいぬ・ねこのきもち」が大リニューアル！\
                                                         愛犬愛猫の写真投稿コーナーが登場♪（2016.08.26）
                                                         """,
                                                     body:
                                                        """
                                                        無料アプリ「まいにちのいぬ・ねこのきもち」が大リニューアル！\
                                                        愛犬愛猫の写真投稿コーナーが登場♪（2016.08.26）
                                                        """,
                                                     thumbnail:
                                                        """
                                                        https://inuneko-media.s3.amazonaws.com/campaign/fabb59\
                                                        4ad064491b3e037ab3ab442dca.png
                                                        """,
                                                     defaultImage: UIImage(named: "no_image"),
                                                     data: nil)
            }
        }.bind(to: cellViewModels).disposed(by: rx.disposeBag)
    }

    func getArticlesWithLoadMore(loadMore: Bool, showIndicator: Bool) {
        if showIndicator == true {
            basicViewModel.progressHUD.showProgressHUD.accept(true)
        }

        // Create mock data
        let mock: Single<[Any]> = Single<[Any]>.create { (single) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                var mockData: [Any] = []
                for _ in 0..<self.limit {
                    mockData.append("")
                }
                single(.success(mockData))
            }
            return Disposables.create()
        }

        guard isLoading == false else { return }
        if loadMore == true && showsInfiniteScrolling.value == false {
            return
        }

        isLoading = true

        if showIndicator == true {
            basicViewModel.progressHUD.showProgressHUD.accept(true)
        }

        let offset = loadMore ? articles.value.count : 0
        //        api.request(MultiTarget(SampleTarget.articleList(limit: limit, offset: offset)))
        //            .map([ArticleInfo].self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
        mock
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    var mutableArray = Array(self.articles.value)
                    if loadMore == false {
                        mutableArray.removeAll()
                        self.count = 3
                    }
                    mutableArray.insert(contentsOf: value, at: mutableArray.count)
                    self.articles.accept(mutableArray)
                    self.count-=1
                    self.showsInfiniteScrolling.accept(self.count > 0)
                case .error:
                    break
                }
                self.basicViewModel.progressHUD.showProgressHUD.accept(false)
                self.endLoadingAnimation.onNext(())
                self.isLoading = false
            }.disposed(by: rx.disposeBag)
    }

    func deleteArticleAtIndex(index: NSInteger) {
        guard let articleInfo = self.cellViewModels.value[index].data as? ArticleInfo else { return }
        if articleInfo.id != nil {
            basicViewModel.progressHUD.showProgressHUD.accept(true)
            var mutableArticles = Array(self.articles.value)
            mutableArticles.remove(at: index)
            self.articles.accept(mutableArticles)
            self.basicViewModel.progressHUD.showProgressHUD.accept(false)
        }
    }
}
