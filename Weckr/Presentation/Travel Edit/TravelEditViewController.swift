//
//  TravelEditViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TravelEditViewController: UIViewController, BindableType {
    
    typealias ViewModelType = TravelEditViewModelType
    
    private var editView = TravelEditView()
    private let disposeBag = DisposeBag()
    private let gradient = Gradient(left: UIColor.walkthroughRedAccent.cgColor,
                                    right: UIColor.backGroundColorTransparent.cgColor)
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
        editView.autoPinEdgesToSuperviewEdges()
        editView.button.setGradientForButton(gradient)
        
        let strings = Strings.Walkthrough.MorningRoutine.self
        editView.topLabel.setTextWithColoredPart(text: strings.title,
                                                 coloredText: strings.titleColored,
                                                 textColor: .white,
                                                 coloredColor: UIColor.walkthroughRedAccent)
    }
    
    func bindViewModel() {
        editView.button.rx.tap
            .withLatestFrom(editView.segmentedControl.rx.selectedSegmentIndex)
            .map { TransportMode(mode: $0) }
            .bind(to: viewModel.actions.dismiss.inputs)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentMode
            .asDriver(onErrorJustReturn: .pedestrian)
            .map { $0.rawValueInt }
            .drive(editView.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}
