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

class TravelEditViewController: UIViewController, BindableType, InfoAlertDisplayable {
    
    typealias ViewModelType = TravelEditViewModelType
    
    private var editView = TravelEditView()
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
        editView.autoPinEdgesToSuperviewEdges()
    }
    
    func bindViewModel() {
        editView.button.rx.tap
            .withLatestFrom(editView.segmentedControl.rx.selectedSegmentIndex)
            .withLatestFrom(editView.weatherSwitch.rx.isOn) { ($0, $1) }
            .bind(to: viewModel.actions.dismiss.inputs)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentMode
            .asDriver(onErrorJustReturn: .pedestrian)
            .map { $0.rawValueInt }
            .delay(0.1) //Frame of segmented control needs to be set before executed
            .drive(editView.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        editView.infoButton.rx.tap
            .map { (Strings.Main.Edit.adjustForWeatherTitle,
                    Strings.Main.Edit.adjustForWeatherInfo) }
            .debug()
            .subscribe(onNext: showInfoAlert)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentSwitchState
            .asDriver(onErrorJustReturn: false)
            .drive(editView.weatherSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
