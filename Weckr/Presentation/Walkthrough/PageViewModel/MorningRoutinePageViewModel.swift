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
    
    //Setup
    let disposeBag = DisposeBag()
    
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
        let strings = Strings.Walkthrough.MorningRoutine.self
        let userDefaults = UserDefaults.standard
        
        //Inputs
        morningRoutineTime = PublishSubject()
        
        //Outputs
        accentColor = Observable.just(UIColor.walkthroughRedAccent.cgColor)
        buttonText = Observable.just(strings.buttonTitle)
        topLabelText = Observable.just(strings.title)
        topLabelColoredText = Observable.just(strings.titleColored)
        bottomLabelText = Observable.just(strings.subtitle)
        bottomLabelColoredText = Observable.just(strings.subtitleColored)
        actionSuccesful = Observable.empty()
        
        morningRoutineTime?.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { time in
                userDefaults.set(time, forKey: SettingsKeys.morningRoutineTime)
                userDefaults.synchronize()
            })
            .disposed(by: disposeBag)
    }
    
    //Actions
    lazy var continueAction: CocoaAction? = nil
}

extension MorningRoutinePageViewModel : WalkthroughSlideableOutputsType, WalkthroughSlideableActionsType, WalkthroughSlideableInputsType {}

