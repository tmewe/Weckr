//
//  NotificationPageViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 17.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action
import UserNotifications

class NotificationPageViewModel : WalkthroughSlideableType {
    
    var inputs: WalkthroughSlideableInputsType { return self }
    var outputs: WalkthroughSlideableOutputsType { return self }
    var actions: WalkthroughSlideableActionsType { return self }
    
    //Setup
    private let disposeBag = DisposeBag()
    private let actionResult = PublishSubject<Bool>()
    
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
    var actionSuccesful: Observable<Bool>
    
    init() {
        
        //Setup
        let strings = Strings.Walkthrough.Notification.self
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughBlueAccent.cgColor)
        buttonText = Observable.just(strings.buttonTitle)
        topLabelText = Observable.just(strings.title)
        topLabelColoredText = Observable.just(strings.titleColored)
        bottomLabelText = Observable.just(strings.subtitle)
        bottomLabelColoredText = Observable.just(strings.subtitleColored)
        actionSuccesful = actionResult.asObservable().startWith(true)
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = {
        return CocoaAction {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound],
                                        completionHandler: {granted, error in
                                            self.actionResult.onNext(granted)
            })
            return Observable.empty()
        }
    }()
}

extension NotificationPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}
