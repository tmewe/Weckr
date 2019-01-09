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
    func showError()
    func hideError()
}

extension ErrorDisplayable where Self: UIViewController {
    func showError() {
        view.addSubview(errorView)
    }
    
    func hideError() {
        errorView.removeFromSuperview()
    }
}
