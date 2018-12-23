//
//  LandingPageViewModel.swift
//  Weckr
//
//  Created by Tim Lehmann on 16.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action

class LandingPageViewModel : WalkthroughSlideableType {
    
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
        accentColor = Observable.just(UIColor.walkthroughPurpleAccent.cgColor)
        buttonText = Observable.just(Strings.Walkthrough.Landing.buttonTitle)
        topLabelText = Observable.just(Strings.Walkthrough.Landing.title)
        topLabelColoredText = Observable.just(Strings.Walkthrough.Landing.titleColored)
        bottomLabelText = Observable.empty()
        bottomLabelColoredText = Observable.empty()
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = nil
}

extension LandingPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}
