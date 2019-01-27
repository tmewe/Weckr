//
//  MainView.swift
//  Weckr
//
//  Created by Tim Mewe on 27.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol WalkthroughViewProtocol {
    var continueButton: RoundedButton { get }
    var previousButton: UIButton { get }
    var pagingView: UIScrollView { get }
    
    func setupSlideScrollView(slides: [WalkthroughPageViewController])
    func updateCurrentPage(pageNumber: Int, pages: [WalkthroughPageViewController])
    func scrollToPage(page: Int)
}

class WalkthroughView: UIView, WalkthroughViewProtocol {
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        addSubview(continueButton)
        addSubview(previousButton)
        addSubview(pagingView)
    }
    
    private func setupConstraints() {
        let nextButtonInsets = Constraints.Buttons.RoundedButton.self
        let previousButtonInsets = Constraints.Buttons.PreviousButton.self
        let edgeInsets = UIEdgeInsets(top: 0,
                                      left: 0,
                                      bottom: previousButtonInsets.bottomOffset,
                                      right: 0)
        
        previousButton.autoPinEdgesToSuperviewSafeArea(with: edgeInsets,
                                                       excludingEdge: .top)
        
        continueButton.autoSetDimensions(to: CGSize(
            width: nextButtonInsets.width,
            height: nextButtonInsets.height))
        continueButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        continueButton.autoPinEdge(.bottom, to: .top, of: previousButton,
                                   withOffset: -nextButtonInsets.bottomOffset)
        
        pagingView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        pagingView.autoPinEdge(.bottom, to: .top, of: continueButton)
    }
    
    func setupSlideScrollView(slides: [WalkthroughPageViewController]) {
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
    
    func updateCurrentPage(pageNumber: Int, pages: [WalkthroughPageViewController]) {
        scrollToPage(page: pageNumber)
    }
    
    func scrollToPage(page: Int) {
        let rect = CGRect(x: CGFloat(page)*pagingView.frame.width,
                          y: 0,
                          width: pagingView.frame.width,
                          height: pagingView.frame.height)
        pagingView.scrollRectToVisible(rect, animated: true)
    }
    
    var continueButton = RoundedButton(text: "How?", gradient: nil)
    
    var previousButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.walkthroughPreviousButtonColor, for: .normal)
        return button
    }()
    
    var pagingView: UIScrollView = {
        let view = UIScrollView.newAutoLayout()
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
}
