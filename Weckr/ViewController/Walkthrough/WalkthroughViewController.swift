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

class WalkthroughViewController: UIViewController, BindableType {
    
    var viewModel: WalkthroughViewModelType!
    
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
        
        let pageNumberAndSlides = Observable.combineLatest(viewModel.outputs.pageNumber, viewModel.outputs.slides)
        
        rx.viewDidLayoutSubviews
            .withLatestFrom(pageNumberAndSlides)
            .subscribe(onNext: updateCurrentPage)
            .disposed(by: disposeBag)
   
        pageNumberAndSlides
            .subscribe(onNext: updateCurrentPage)
            .disposed(by: disposeBag)
        
        viewModel.outputs.pageNumber
            .map { ($0 == 0) }
            .asDriver(onErrorJustReturn: true)
            .drive (previousButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.buttonColor
            .asDriver(onErrorJustReturn: UIColor.walkthroughPurpleAccent)
            .map{[$0.cgColor, UIColor.backGroundColorTransparent.cgColor]}
            .debug()
            .drive(continueButton.rx.gradientColor)
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
        continueButton.autoSetDimensions(to: CGSize(
            width: Constraints.Walkthrough.NextButton.width,
            height: Constraints.Walkthrough.NextButton.height))
        continueButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        continueButton.autoPinEdge(.bottom, to: .bottom, of: view,
                                   withOffset: -Constraints.Walkthrough.NextButton.bottomOffset)
        
        previousButton.autoSetDimensions(to: CGSize(
            width: Constraints.Walkthrough.NextButton.width,
            height: Constraints.Walkthrough.NextButton.bottomOffset))
        previousButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        previousButton.autoPinEdge(.top, to: .bottom, of: continueButton)
        
        pagingView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        pagingView.autoPinEdge(.bottom, to: .top, of: continueButton)
        
      
    }
    
    
    private func setupSlideScrollView(slides: [WalkthroughSlideWrapper]) {
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

    
    private func updateCurrentPage(pageNumber: Int, pages: [WalkthroughSlideWrapper]) {
        scrollToPage(page: pageNumber)
        updateContinueButtonLook(text: pages[pageNumber].buttonText, color: pages[pageNumber].buttonColor)
    }
    
    private func scrollToPage(page: Int) {
        let rect = CGRect(x: CGFloat(page)*pagingView.frame.width, y: 0, width: pagingView.frame.width, height: pagingView.frame.height)
        pagingView.scrollRectToVisible(rect, animated: true)
    }
    
    private func updateContinueButtonLook (text: String, color: UIColor) {
        continueButton.setTitle(text, for: .normal)
        //continueButton.setGradientBackground(colorOne: color, colorTwo: .backGroundColorTransparent)
    }
    
    private func updatePreviousButtonVisibility(visible: Bool) {
        previousButton.isHidden = !visible
    }
    
    let continueButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("How?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = button.layer.frame.height / 2
        button.layer.masksToBounds = true
        return button
    }()
    
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
