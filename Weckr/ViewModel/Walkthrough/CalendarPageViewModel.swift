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
        accentColor = Observable.just(UIColor.walkthroughGreenAccent.cgColor)
        buttonText = Observable.just("walkthrough.calendar.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.calendar.title".localized())
        topLabelColoredText = Observable.just("walkthrough.calendar.title.coloredPart".localized())
        bottomLabelText = Observable.just("walkthrough.calendar.title2".localized())
        bottomLabelColoredText = Observable.just("walkthrough.calendar.title2.coloredPart".localized())
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = {
        return CocoaAction {
            let calendarAccess = UserDefaults.standard.bool(forKey: Constants.UserDefaults.CalendarAccess)
            guard calendarAccess == false else {
                return Observable.empty()
            }
            
            let status = EKEventStore.authorizationStatus(for: .event)
            switch (status) {
            case .notDetermined:
                break
            case .authorized:
                return Observable.empty()
            case .restricted, .denied:
                return Observable.empty()
            }
            
            print("yeaaaag")
            return Observable.empty()
        }
    }()
}

extension CalendarPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType {}
