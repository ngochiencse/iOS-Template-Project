//
//  TutorialViewController.swift
//  ios_template_project
//
//  Created by Hien Pham on 8/22/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import SnapKit
import FSPagerView

protocol TutorialViewControllerDelegate: class {
    func tutorialGoNext(tutorial: TutorialViewController)
}

class TutorialViewController: BaseViewController {
    weak var delegate: TutorialViewControllerDelegate?

    // View
    @IBOutlet private weak var pageControl: UIPageControl?
    private var lineArray: [UIView] = []
    @IBOutlet private weak var finishButton: UIButton!
    @IBOutlet private weak var finishView: UIView!
    private let reuseId: String = String(describing: TutorialCell.self)
    @IBOutlet weak var pageView: FSPagerView!

    // ViewModel
    let viewModel: TutorialViewModel

    init(viewModel: TutorialViewModel = TutorialViewModelImpl()) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarHidden = true
        pageControl?.numberOfPages = viewModel.imageArray.count
        pageView.register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)
        pageView.dataSource = self
        pageView.delegate = self

        let pageControlView: UIView = UIView()
        view.addSubview(pageControlView)
        pageControlView.snp.makeConstraints {[weak self] (make) in
            guard let self = self else { return }
            if #available(iOS 11, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(12)
            } else {
                make.top.equalToSuperview().offset(12)
            }
            make.centerX.equalToSuperview()
        }
        var lineArray: [UIView] = Array()
        for index in 0...self.viewModel.imageArray.count - 1 {
            let item: UIView = UIView()
            item.backgroundColor = UIColor.white
            item.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 24, height: 2))
            }
            pageControlView.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            if index == 0 {
                item.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                }
            } else if index == viewModel.imageArray.count - 1 {
                item.snp.makeConstraints { (make) in
                    make.right.equalToSuperview()
                }
            }

            let previous: UIView? = index > 0 ? lineArray[index - 1] : nil
            if previous != nil {
                item.snp.makeConstraints { (make) in
                    make.left.equalTo(previous!.snp.right).offset(4)
                }
            }

            lineArray.append(item)
        }
        self.lineArray = lineArray
        setSelectedLineAtIndex(index: 0)

        let title: String = "Start work"
        finishButton.setTitle(title, for: UIControl.State.normal)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setSelectedLineAtIndex(index: Int) {
        if index >= 0 && index < lineArray.count {
            for lineIndex in 0...lineArray.count - 1 {
                let lineView: UIView = lineArray[lineIndex]
                lineView.alpha = (lineIndex == index) ? 1.0 : 0.2
            }
            finishView.isHidden = (index != lineArray.count - 1)
        }
    }

    @IBAction private func changePage(sender: Any) {
        let page: Int = pageControl!.currentPage
        pageView.selectItem(at: page, animated: true)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        delegate?.tutorialGoNext(tutorial: self)
    }
}

extension TutorialViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.imageArray.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell: TutorialCell! = pagerView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                                at: index) as? TutorialCell
        cell.contentImageView.image = viewModel.imageArray[index]
        return cell
    }
}

extension TutorialViewController: FSPagerViewDelegate {
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        setSelectedLineAtIndex(index: pagerView.currentIndex)
    }
}
