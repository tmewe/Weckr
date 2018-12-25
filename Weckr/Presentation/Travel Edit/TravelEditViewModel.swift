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
}

protocol TravelEditViewModelOutputsType {
    var currentMode: Observable<TransportMode> { get }
}

protocol TravelEditViewModelActionsType {
    var dismiss: Action<TransportMode, Void> { get }
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
    
    //Outputs
    var currentMode: Observable<TransportMode>
    
    //Setup
    private let coordinator: SceneCoordinatorType
    
    init(mode: TransportMode, coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
        
        //Inputs
        transportMode = PublishSubject()
        
        //Outputs
        currentMode = Observable.just(mode)
    }
    
    //Actions
    lazy var dismiss: Action<TransportMode, Void> = { [weak self] this in
        return Action { mode in
            //            self?.alarmService
            let userDefaults = UserDefaults.standard
            userDefaults.set(mode.rawValueInt, forKey: SettingsKeys.travelMode)
            userDefaults.synchronize()
            return this.coordinator.pop(animated: true)
        }
        }(self)
}

extension TravelEditViewModel: TravelEditViewModelInputsType, TravelEditViewModelOutputsType, TravelEditViewModelActionsType {}
