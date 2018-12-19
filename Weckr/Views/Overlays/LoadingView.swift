//
//  LoadingView.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingProtocol {
    func starLoading()
    func stopLoading()
}

class LoadingView: UIView, LoadingProtocol {
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(spinner)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func starLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        spinner.stopAnimating()
    }
    
    private func setupView() {
        backgroundColor = .black
        alpha = 0.7
    }
    
    private func setupConstraints() {
        spinner.autoCenterInSuperview()
    }
    
    let spinner: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.startAnimating()
        return spinner
    }()
}
