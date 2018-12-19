//
//  LoadingPresentable.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingDisplayable {
    typealias LoadingViewProtocol = LoadingProtocol & UIView
    var loadingView: LoadingViewProtocol { get set }
    func showLoading()
    func hideLoading()
}

extension LoadingDisplayable where Self: UIViewController {
    func showLoading() {
        loadingView.starLoading()
        view.addSubview(loadingView)
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
        loadingView.stopLoading()
    }
}
