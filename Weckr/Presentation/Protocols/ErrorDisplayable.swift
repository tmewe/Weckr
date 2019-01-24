//
//  ErrorDisplayable.swift
//  Weckr
//
//  Created by Tim Mewe on 09.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorDisplayable {
    typealias ErrorViewProtocol = ErrorProtocol & UIView
    var errorView: ErrorViewProtocol { get set }
    func showError(error: AppError)
    func hideError()
}

extension ErrorDisplayable where Self: UIViewController {
    func showError(error: AppError) {
        errorView.setError(error)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.backGroundColorTransparent
        view.addSubview(errorView)
    }
    
    func hideError() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.backgroundColor
        errorView.removeFromSuperview()
    }
}
