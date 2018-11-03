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

class WalkthroughViewController: UIViewController {
    
    private var viewModel: WalkthroughViewModelType!
    
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
        return view
    }()
}
