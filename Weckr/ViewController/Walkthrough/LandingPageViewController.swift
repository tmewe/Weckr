//
//  LandingPageViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 03.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    private var viewModel: LandingPageViewModel!
    
    init(viewModel: LandingPageViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        view.addSubview(topLabel)
    }
    
    func setupConstraints() {
        topLabel.autoPinEdge(.top, to: .top, of: view, withOffset: Constraints.Walkthrough.Title.title1Top)
        topLabel.autoPinEdge(.left, to: .left, of: view, withOffset: Constraints.Walkthrough.Title.horizontalSides)
        topLabel.autoSetDimension(.width, toSize: Constraints.Walkthrough.Title.width)
    }

    
    
    let topLabel: UILabel = {
        var label = UILabel.newAutoLayout()
    
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
}
