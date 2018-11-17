//
//  LocationPageViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 17.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action

class LocationPageViewModel : WalkthroughSlideableType {
    
    var outputs: WalkthroughSlideableOutputsType { return self }
    var actions: WalkthroughSlideableActionsType { return self }
    
    //Outputs
    var accentColor: Observable<CGColor>
    var buttonText: Observable<String>
    var topLabelText: Observable<String>
    var topLabelColoredText: Observable<String>
    var bottomLabelText: Observable<String>
    var bottomLabelColoredText: Observable<String>
    
    init() {
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughOrangeAccent.cgColor)
        buttonText = Observable.just("walkthrough.location.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.location.title".localized())
        topLabelColoredText = Observable.just("walkthrough.location.title.coloredPart".localized())
        bottomLabelText = Observable.just("walkthrough.location.title2".localized())
        bottomLabelColoredText = Observable.just("walkthrough.location.title2.coloredPart".localized())
    }
    
    
    //Actions
    lazy var onNextAction: CocoaAction? = nil
}

extension LocationPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType {}
