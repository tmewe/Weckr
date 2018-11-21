//
//  TravelPageViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 21.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action

class DonePageViewModel : WalkthroughSlideableType {
    
    var inputs: WalkthroughSlideableInputsType { return self }
    var outputs: WalkthroughSlideableOutputsType { return self }
    var actions: WalkthroughSlideableActionsType { return self }
    
    //Inputs
    var vehicle: PublishSubject<Vehicle>?
    var morningRoutineTime: PublishSubject<TimeInterval>?
    
    //Outputs
    var accentColor: Observable<CGColor>
    var buttonText: Observable<String>
    var topLabelText: Observable<String>
    var topLabelColoredText: Observable<String>
    var bottomLabelText: Observable<String>
    var bottomLabelColoredText: Observable<String>
    
    init() {
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughTealAccent.cgColor)
        buttonText = Observable.just("walkthrough.done.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.done.title".localized())
        topLabelColoredText = Observable.just("walkthrough.done.title.coloredPart".localized())
        bottomLabelText = Observable.just("walkthrough.done.title2".localized())
        bottomLabelColoredText = Observable.just("walkthrough.done.title2.coloredPart".localized())
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = nil
}

extension DonePageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}

