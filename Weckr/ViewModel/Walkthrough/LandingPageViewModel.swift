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
    
    var outputs: WalkthroughSlideableOutputsType { return self }
    
    var actions: WalkthroughSlideableActionsType { return self }
    
    
    //Outputs
    var accentColor: Observable<CGColor>
    var buttonText: Observable<String>
    var topLabelText: Observable<String>
    var topLabelColorPart: Observable<String>
    var bottomLabelText: Observable<String>
    var bottomLabelColorPart: Observable<String>
    
    init() {
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughPurpleAccent.cgColor)
        buttonText = Observable.just("walkthrough.landing.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.landing.title".localized())
        topLabelColorPart = Observable.just("walkthrough.landing.title.coloredPart".localized())
        bottomLabelText = Observable.empty()
        bottomLabelColorPart = Observable.empty()
    }
    
    
    //Actions
    lazy var onNextAction: CocoaAction? = nil
}

extension LandingPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType {}
