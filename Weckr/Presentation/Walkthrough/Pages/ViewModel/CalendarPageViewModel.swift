//
//  CalendarPageViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 17.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action
import EventKit

class CalendarPageViewModel : WalkthroughSlideableType {
    
    var inputs: WalkthroughSlideableInputsType { return self }
    var outputs: WalkthroughSlideableOutputsType { return self }
    var actions: WalkthroughSlideableActionsType { return self }
    
    //Setup
    private let disposeBag = DisposeBag()
    
    //Inputs
    var transportMode: PublishSubject<TransportMode>?
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
        let strings = Strings.Walkthrough.Calendar.self
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughGreenAccent.cgColor)
        buttonText = Observable.just(strings.buttonTitle)
        topLabelText = Observable.just(strings.title)
        topLabelColoredText = Observable.just(strings.titleColored)
        bottomLabelText = Observable.just(strings.subtitle)
        bottomLabelColoredText = Observable.just(strings.subtitleColored)
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = {
        return CocoaAction {
            let status = EKEventStore.authorizationStatus(for: .event)
            switch (status) {
            case .notDetermined:
                EKEventStore().requestAccess(to: .event, completion: {_,_ in })
            case .authorized:
                return Observable.empty()
            case .restricted, .denied:
                return Observable.empty()
            }
        return Observable.empty()
        }
    }()
}

extension CalendarPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}
