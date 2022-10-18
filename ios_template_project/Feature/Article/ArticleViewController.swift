//
//  ArticleViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SnapKit
import RxSwift
import UIScrollView_InfiniteScroll

protocol ArticleViewControllerDelegate: class {
    func articleViewController(_ articleViewController: ArticleViewController, didSelect article: ArticleInfo)
}

class ArticleViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private(set) var viewModel: ArticleViewModel
    weak var delegate: ArticleViewControllerDelegate?

    @IBOutlet private weak var listTableView: UITableView!
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    private let disposeBag: DisposeBag = DisposeBag()

    init(viewModel: ArticleViewModel = ArticleViewModelImpl()) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTableView()
        setUpNavigationBar()
        bindToViewModel()
    }

    private func bindToViewModel() {
        viewModel.endLoadingAnimation.observeOn(MainScheduler.instance).subscribe {[weak self] (_) in
            guard let self = self else { return }
            self.listTableView.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)

        viewModel.cellViewModels.observeOn(MainScheduler.instance).subscribe {[weak self] (_) in
            self?.listTableView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.showsInfiniteScrolling.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (showsInfiniteScrolling) in
                guard let self = self else { return }
                self.listTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
                    return showsInfiniteScrolling
                }
            }).disposed(by: rx.disposeBag)
    }

    private func setTableView() {
        listTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        listTableView.register(UINib(nibName: String(describing: ArticleTableCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: ArticleTableCell.self))
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        listTableView.tableHeaderView = view
        listTableView.tableFooterView = view

        refreshControl.addTarget(self,
                                 action: #selector(refreshControlTriggered(sender:)),
                                 for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            self.listTableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }

        view.activityIndicator.style = .gray

        listTableView.addInfiniteScroll {[weak self](_) -> Void in
            guard let self = self else { return }
            self.viewModel.getArticlesWithLoadMore(loadMore: true, showIndicator: false)
        }

        viewModel.getArticlesWithLoadMore(loadMore: false, showIndicator: true)
    }

    // Demo layout buttons on navigation bar
    private func setUpNavigationBar() {
        var buttons: [UIButton] = []
        do {
            let image: UIImage = UIImage(named: "btn_fav_on_navigation")!
            let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width + 10, height: 44))
            button.setImage(image, for: UIControl.State.normal)
            button.snp.makeConstraints { (make) in
                make.size.width.equalTo(button.frame.size.width)
            }
            button.addTarget(self,
                             action: #selector(ArticleViewController.addButtonClicked(sender:)),
                             for: UIControl.Event.touchUpInside)
            buttons.append(button)
        }

        do {
            let image: UIImage = UIImage(named: "icon_menu")!
            let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width + 10, height: 44))
            button.setImage(image, for: UIControl.State.normal)
            button.snp.makeConstraints { (make) in
                make.size.width.equalTo(button.frame.size.width)
            }
            button.addTarget(self,
                             action: #selector(ArticleViewController.trashButtonClicked(sender:)),
                             for: UIControl.Event.touchUpInside)
            buttons.append(button)
        }

        let container: UIStackView = UIStackView(arrangedSubviews: buttons)
        let barButtonItem = UIBarButtonItem(customView: container)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @IBAction private  func addButtonClicked(sender: Any) {
    }

    @IBAction private func trashButtonClicked(sender: Any) {
        listTableView.setEditing(!listTableView.isEditing, animated: true)
    }

    @objc private func refreshControlTriggered(sender: Any) {
        viewModel.getArticlesWithLoadMore(loadMore: false, showIndicator: false)
    }

    @IBAction func trashButtonClicked(_ sender: Any) {
        listTableView.setEditing(!self.listTableView.isEditing, animated: true)
    }

    // MARK: - UITableView Datasource / Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleTableCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ArticleTableCell.self),
            for: indexPath) as? ArticleTableCell
        cell.viewModel = viewModel.cellViewModels.value[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
        viewModel.deleteArticleAtIndex(index: indexPath.row)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let articleInfo: ArticleInfo = viewModel
                .cellViewModels.value[indexPath.row].data as? ArticleInfo else { return }
        delegate?.articleViewController(self, didSelect: articleInfo)
    }
}
