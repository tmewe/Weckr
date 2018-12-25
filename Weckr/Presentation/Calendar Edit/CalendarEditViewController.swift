//
//  CalendarEditViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CalendarEditViewController: UIViewController, BindableType {
    
    typealias ViewModelType = CalendarEditViewModelType
    
    private let editView = CalendarEditView()
    private let disposeBag = DisposeBag()
    var viewModel: ViewModelType!
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.isOpaque = false
        view.backgroundColor = .clear
        view.addSubview(editView)
        editView.autoPinEdgesToSuperviewSafeArea()
    }
    
    func bindViewModel() {
    }
}
