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

class MorningRoutinePageViewModel : WalkthroughSlideableType {
    
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
        
        //Inputs
        morningRoutineTime = PublishSubject()
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughRedAccent.cgColor)
        buttonText = Observable.just("walkthrough.morningroutine.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.morningroutine.title".localized())
        topLabelColoredText = Observable.just("walkthrough.morningroutine.title.coloredPart".localized())
        bottomLabelText = Observable.just("walkthrough.morningroutine.title2".localized())
        bottomLabelColoredText = Observable.just("walkthrough.morningroutine.title2.coloredPart".localized())
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = nil
}

extension MorningRoutinePageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}

