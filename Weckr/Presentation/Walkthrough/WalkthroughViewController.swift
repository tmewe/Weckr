//
//  WalkthroughViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 03.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import RxSwift
import RxViewController

class WalkthroughViewController: UIViewController, BindableType, LoadingDisplayable {
    
    var viewModel: WalkthroughViewModelType!
    var loadingView: LoadingViewProtocol = LoadingView.newAutoLayout()
    private var disposeBag = DisposeBag()
    
    init(viewModel: WalkthroughViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
                
        addSubview()
        setupConstraints()
    }
        
    func bindViewModel() {
        
        rx.viewDidLayoutSubviews
            .withLatestFrom(viewModel.outputs.slides)
            .subscribe(onNext: setupSlideScrollView)
            .disposed(by: disposeBag)
        
        let pageNumberAndSlides = Observable.combineLatest(viewModel.outputs.pageNumber,
                                                           viewModel.outputs.slides)
        
        Observable.combineLatest(rx.viewDidLayoutSubviews, pageNumberAndSlides)
            .map { $0.1 }
            .subscribe(onNext: updateCurrentPage)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(rx.viewDidLayoutSubviews, viewModel.outputs.buttonColor)
            .map { $0.1 }
            .asDriver(onErrorJustReturn: UIColor.walkthroughPurpleAccent.cgColor)
            .map { ($0, UIColor.backGroundColorTransparent.cgColor) }
            .map(Gradient.init)
            .drive(continueButton.rx.gradientColorButton)
            .disposed(by: disposeBag)
        
        viewModel.outputs.buttonText
            .asDriver(onErrorJustReturn: Strings.Walkthrough.Landing.buttonTitle)
            .drive(continueButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.outputs.pageNumber
            .map { ($0 == 0) }
            .asDriver(onErrorJustReturn: true)
            .drive (previousButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.createTrigger
            .subscribe({ _ in
                self.showLoading()
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind(to: viewModel.inputs.nextPage)
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .bind(to: viewModel.inputs.previousPage)
            .disposed(by: disposeBag)
        
        pagingView.rx.contentOffset
            .map{ $0.x / self.pagingView.frame.width }
            .filter{ $0 >= 0 }
            .bind(to: viewModel.inputs.scrollAmount)
            .disposed(by: disposeBag)
    }
    
    private func addSubview() {
        view.addSubview(continueButton)
        view.addSubview(previousButton)
        view.addSubview(pagingView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Walkthrough.self
        let nextButtonInsets = insets.NextButton.self
        let previousButtonInsets = insets.PreviousButton.self
        let edgeInsets = UIEdgeInsets(top: 0,
                                     left: 0,
                                     bottom: previousButtonInsets.bottomOffset,
                                     right: 0)
        
        previousButton.autoPinEdgesToSuperviewSafeArea(with: edgeInsets,
                                                       excludingEdge: .top)
        
        continueButton.autoSetDimensions(to: CGSize(
            width: nextButtonInsets.width,
            height: nextButtonInsets.height))
        continueButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        continueButton.autoPinEdge(.bottom, to: .top, of: previousButton,
                                   withOffset: -nextButtonInsets.bottomOffset)
        
        pagingView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        pagingView.autoPinEdge(.bottom, to: .top, of: continueButton)
        
        loadingView.autoSetDimensions(to: view.frame.size)
    }
    
    
    private func setupSlideScrollView(slides: [WalkthroughPageViewController]) {
        pagingView.contentSize = CGSize(width: pagingView.frame.width * CGFloat(slides.count),
                                        height: pagingView.frame.height)
        
        for i in 0 ..< slides.count {
            slides[i].view.frame = CGRect(x: pagingView.frame.width * CGFloat(i),
                                     y: 0,
                                     width: pagingView.frame.width,
                                     height: pagingView.frame.height)
            pagingView.addSubview(slides[i].view)
        }
    }
    
    private func updateCurrentPage(pageNumber: Int, pages: [WalkthroughPageViewController]) {
        scrollToPage(page: pageNumber)
    }
    
    private func scrollToPage(page: Int) {
        let rect = CGRect(x: CGFloat(page)*pagingView.frame.width,
                          y: 0,
                          width: pagingView.frame.width,
                          height: pagingView.frame.height)
        pagingView.scrollRectToVisible(rect, animated: true)
    }
    
    let continueButton = RoundedButton(text: "How?", gradient: nil)
    
    let previousButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.walkthroughPreviousButtonColor, for: .normal)
        return button
    }()
    
    let pagingView: UIScrollView = {
        let view = UIScrollView.newAutoLayout()
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
}
