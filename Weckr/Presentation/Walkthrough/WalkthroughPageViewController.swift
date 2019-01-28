//
//  WalkthroughPageController.swift
//  Weckr
//
//  Created by Tim Lehmann on 16.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class WalkthroughPageViewController: UIViewController {
    var viewModel: WalkthroughSlideableType!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: WalkthroughSlideableType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        
        if viewModel.inputs.transportMode != nil {
            setupSegmentedControl()
        }
        
        if viewModel.inputs.morningRoutineTime != nil {
            setupDatePicker()
        }
    }
    
    private func setupConstraints() {
        let insets = Constraints.Walkthrough.Title.self
        
        topLabel.autoPinEdge(.top, to: .top, of: view, withOffset: insets.title1Top)
        topLabel.autoPinEdge(.left, to: .left, of: view, withOffset: insets.horizontalSides)
        topLabel.autoSetDimension(.width, toSize: insets.width)
        
        bottomLabel.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -insets.title2Bottom)
        bottomLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -insets.horizontalSides)
        bottomLabel.autoSetDimension(.width, toSize: insets.width)
    }
    
    private func bindViewModel() {
        Observable.combineLatest(viewModel.outputs.topLabelText,
                                 viewModel.outputs.topLabelColoredText,
                                 viewModel.outputs.accentColor)
            .asDriver(onErrorJustReturn: ("", "", UIColor.white.cgColor))
            .drive(onNext: { [weak self] (t,c,a) in
                self?.topLabel.setTextWithColoredPart(text: t,
                                                      coloredText: c,
                                                      textColor: .white,
                                                      coloredColor: UIColor(cgColor: a))
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.outputs.bottomLabelText,
                                 viewModel.outputs.bottomLabelColoredText,
                                 viewModel.outputs.accentColor)
            .asDriver(onErrorJustReturn: ("", "", UIColor.white.cgColor))
            .drive(onNext: { [weak self] (t,c,a) in
                self?.bottomLabel.setTextWithColoredPart(text: t,
                                                         coloredText: c,
                                                         textColor: .white,
                                                         coloredColor: UIColor(cgColor: a))
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.autoSetDimensions(to: CGSize(width: 300, height: 65))
        segmentedControl.autoCenterInSuperview()
        segmentedControl.rx.selectedSegmentIndex
            .map { TransportMode(mode: $0) }
            .startWith(.car)
            .bind(to: viewModel.inputs.transportMode!)
            .disposed(by: disposeBag)
    }
    
    private func setupDatePicker() {
        view.addSubview(datePicker)
        datePicker.autoCenterInSuperview()
        datePicker.rx.countDownDuration
            .bind(to: viewModel.inputs.morningRoutineTime!)
            .disposed(by: disposeBag)
    }
    
    let topLabel = WalkthroughTitleLabel(title: "", alignment: .left)
    let bottomLabel = WalkthroughTitleLabel(title: "", alignment: .right)
    let segmentedControl: VehicleSegmentedControl = {
        return VehicleSegmentedControl(imageNames: "car", "walk", "bus")
    }()
    let datePicker = TimePicker()
}
