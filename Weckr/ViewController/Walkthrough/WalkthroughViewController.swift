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
        
        view.backgroundColor = .blue
        
        addSubview()
        setupConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.outputs.slides
            .subscribe(onNext: setupSlideScrollView)
            .disposed(by: disposeBag)
        
        viewModel.outputs.pageNumber
            .subscribe(onNext: scrollToPage)
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind(to: viewModel.inputs.nextPage)
            .disposed(by: disposeBag)
        
    }
    
    private func addSubview() {
        view.addSubview(continueButton)
        view.addSubview(pagingView)
    }
    
    private func setupConstraints() {
        continueButton.autoSetDimensions(to: CGSize(width: 200, height: 60))
        continueButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        continueButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -65.0)
        
        pagingView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        pagingView.autoPinEdge(.bottom, to: .top, of: continueButton)
    }
    
    
    
    private func setupSlideScrollView(slides: [UIView]) {
        pagingView.contentSize = CGSize(width: pagingView.frame.width * CGFloat(slides.count),
                                        height: pagingView.frame.height)
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: pagingView.frame.width * CGFloat(i),
                                     y: 0,
                                     width: pagingView.frame.width,
                                     height: pagingView.frame.height)
            pagingView.addSubview(slides[i])
        }
    }
    
    private func scrollToPage(page: Int) {
        let rect = CGRect(x: CGFloat(page)*pagingView.frame.width, y: 0, width: pagingView.frame.width, height: pagingView.frame.height)
        pagingView.scrollRectToVisible(rect, animated: true)
    }
    
    let continueButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("How?", for: .normal)
        button.backgroundColor = .purple
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
