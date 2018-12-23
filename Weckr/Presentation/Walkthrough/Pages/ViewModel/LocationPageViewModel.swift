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
import CoreLocation

class LocationPageViewModel : WalkthroughSlideableType {
    
    var inputs: WalkthroughSlideableInputsType { return self }
    var outputs: WalkthroughSlideableOutputsType { return self }
    var actions: WalkthroughSlideableActionsType { return self }
    
    //Setup
    private let locationManager = CLLocationManager()
    
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
        
        //Setup
        let strings = Strings.Walkthrough.Location.self
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughOrangeAccent.cgColor)
        buttonText = Observable.just(strings.buttonTitle)
        topLabelText = Observable.just(strings.title)
        topLabelColoredText = Observable.just(strings.titleColored)
        bottomLabelText = Observable.just(strings.subtitle)
        bottomLabelColoredText = Observable.just(strings.subtitleColored)
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = {
        return CocoaAction {
            self.locationManager.requestAlwaysAuthorization()
            return Observable.empty()
        }
    }()
}

extension LocationPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}
