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
        accentColor = Observable.just(UIColor.walkthroughBlueAccent.cgColor)
        buttonText = Observable.just("walkthrough.notification.buttonTitle".localized())
        topLabelText = Observable.just("walkthrough.notification.title".localized())
        topLabelColoredText = Observable.just("walkthrough.notification.title.coloredPart".localized())
        bottomLabelText = Observable.just("walkthrough.notification.title2".localized())
        bottomLabelColoredText = Observable.just("walkthrough.notification.title2.coloredPart".localized())
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = {
        return CocoaAction {
            let defaults = UserDefaults.standard
            let notifications = defaults.bool(forKey: Constants.UserDefaults.NotificationAuthorization)
            guard notifications == false else {
                return Observable.empty()
            }
            let center = UNUserNotificationCenter.current()
            center.rx.requestAuthorization(options: [.badge, .alert, .sound])
                .map { $0.0 }
                .subscribe(onNext: { granted in
                    defaults.set(granted, forKey: Constants.UserDefaults.NotificationAuthorization)
                })
                .disposed(by: self.disposeBag)
            return Observable.empty()
        }
    }()
}

extension NotificationPageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}
