
//
//  File.swift
//  Weckr
//
//  Created by Tim Lehmann on 07.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType {
    associatedtype ViewModelType
    var viewModel : ViewModelType! {get set}
    func bindViewModel()
    
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel() {
        loadViewIfNeeded()
        bindViewModel()
    }
}
