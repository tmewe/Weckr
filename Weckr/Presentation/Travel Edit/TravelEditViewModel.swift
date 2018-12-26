//
//  TravelEditViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol TravelEditViewModelInputsType {
    var transportMode: PublishSubject<TransportMode> { get }
    var toggleSwitch: PublishSubject<Void> { get }
}

protocol TravelEditViewModelOutputsType {
    var currentMode: Observable<TransportMode> { get }
    var currentSwitchState: Observable<Bool> { get }
}

protocol TravelEditViewModelActionsType {
    var dismiss: Action<(Int, Bool), Void> { get }
}

protocol TravelEditViewModelType {
    var inputs: TravelEditViewModelInputsType { get }
    var outputs: TravelEditViewModelOutputsType { get }
    var actions: TravelEditViewModelActionsType { get }
}

class TravelEditViewModel: TravelEditViewModelType {
    var inputs: TravelEditViewModelInputsType { return self }
    var outputs: TravelEditViewModelOutputsType { return self }
    var actions: TravelEditViewModelActionsType { return self }
    
    //Inputs
    var transportMode: PublishSubject<TransportMode>
    var toggleSwitch: PublishSubject<Void>
    
    //Outputs
    var currentMode: Observable<TransportMode>
    var currentSwitchState: Observable<Bool>
    
    //Setup
    private let disposeBag = DisposeBag()
    private let coordinator: SceneCoordinatorType
    private let mode: TransportMode
    private let switchState: Bool
    
    init(mode: TransportMode, coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
        self.mode = mode
        
        let userDefaults = UserDefaults.standard
        switchState = userDefaults.bool(forKey: SettingsKeys.adjustForWeather)
        
        //Inputs
        transportMode = PublishSubject()
        toggleSwitch = PublishSubject()
        
        //Outputs
        currentMode = Observable.just(mode)
        currentSwitchState = Observable.just(switchState)
    }
    
    //Actions
    lazy var dismiss: Action<(Int, Bool), Void> = { [weak self] this in
        return Action { transportMode, switchState in
            let userDefaults = UserDefaults.standard

            if switchState != self?.switchState {
                userDefaults.set(switchState, forKey: SettingsKeys.adjustForWeather)
            }
            
            if transportMode != self?.mode.rawValueInt {
                userDefaults.set(transportMode, forKey: SettingsKeys.transportMode)
            }
            userDefaults.synchronize()
            return this.coordinator.pop(animated: true)
        }
        }(self)
}

extension TravelEditViewModel: TravelEditViewModelInputsType, TravelEditViewModelOutputsType, TravelEditViewModelActionsType {}
