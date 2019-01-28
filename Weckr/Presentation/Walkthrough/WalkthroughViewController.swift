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
import RxAppState
import RxViewController

class WalkthroughViewController: UIViewController, BindableType, LoadingDisplayable, ErrorDisplayable, InfoAlertDisplayable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    var viewModel: WalkthroughViewModelType!
    var loadingView: LoadingViewProtocol = LoadingView.newAutoLayout()
    var errorView: ErrorViewProtocol = ErrorView.newAutoLayout()
    private var walkthroughView = WalkthroughView()
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
        setupViews()
    }
        
    func bindViewModel() {
        
        rx.viewWillLayoutSubviews
            .withLatestFrom(viewModel.outputs.slides)
            .subscribe(onNext: walkthroughView.setupSlideScrollView)
            .disposed(by: disposeBag)
        
        UIApplication.shared.rx.didOpenApp
            .map { _ in Void() }
            .bind(to: viewModel.inputs.viewWillAppear)
            .disposed(by: disposeBag)
        
        let pageNumberAndSlides = Observable.combineLatest(viewModel.outputs.pageNumber,
                                                           viewModel.outputs.slides)
        
        Observable.combineLatest(rx.viewWillLayoutSubviews, pageNumberAndSlides)
            .map { $0.1 }
            .subscribe(onNext: walkthroughView.updateCurrentPage)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(rx.viewWillLayoutSubviews, viewModel.outputs.buttonColor)
            .map { $0.1 }
            .asDriver(onErrorJustReturn: UIColor.walkthroughPurpleAccent.cgColor)
            .map { ($0, UIColor.backGroundColorTransparent.cgColor) }
            .map(Gradient.init)
            .drive(walkthroughView.continueButton.rx.gradientColorButton)
            .disposed(by: disposeBag)
        
        viewModel.outputs.buttonText
            .asDriver(onErrorJustReturn: Strings.Walkthrough.Landing.buttonTitle)
            .drive(walkthroughView.continueButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.outputs.pageNumber
            .map { ($0 == 0) }
            .asDriver(onErrorJustReturn: true)
            .drive (walkthroughView.previousButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.showLoading
            .filter { $0 }
            .subscribe({ _ in self.showLoading() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.showLoading
            .filter(!)
            .subscribe({ _ in self.hideLoading() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorOccurred
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext:  { $0 == nil ? self.hideError() : self.showError(error: $0!) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.showAlert
            .subscribe(onNext: showInfoAlert)
            .disposed(by: disposeBag)
        
        walkthroughView.continueButton.rx.tap
            .bind(to: viewModel.inputs.nextPage)
            .disposed(by: disposeBag)
        
        walkthroughView.previousButton.rx.tap
            .bind(to: viewModel.inputs.previousPage)
            .disposed(by: disposeBag)
        
        walkthroughView.pagingView.rx.contentOffset
            .map{ $0.x / self.walkthroughView.pagingView.frame.width }
            .filter{ $0 >= 0 }
            .bind(to: viewModel.inputs.scrollAmount)
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(walkthroughView)
        walkthroughView.autoPinEdgesToSuperviewEdges()
        loadingView.autoSetDimensions(to: view.frame.size)
        errorView.autoSetDimensions(to: view.frame.size)
    }
    
    private func setupConstraints() {
        loadingView.autoSetDimensions(to: view.frame.size)
        errorView.autoSetDimensions(to: view.frame.size)
    }
}
