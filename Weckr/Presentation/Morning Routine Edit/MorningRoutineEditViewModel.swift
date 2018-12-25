//
//  MorningRoutineEditViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol MorningRoutineEditViewModelInputsType {
    var time: PublishSubject<TimeInterval> { get }
}

protocol MorningRoutineEditViewModelOutputsType {
    var currentTime: Observable<TimeInterval> { get }
}

protocol MorningRoutineEditViewModelActionsType {
    var dismiss: Action<TimeInterval, Void> { get }
}

protocol MorningRoutineEditViewModelType {
    var inputs: MorningRoutineEditViewModelInputsType { get }
    var outputs: MorningRoutineEditViewModelOutputsType { get }
    var actions: MorningRoutineEditViewModelActionsType { get }
}

class MorningRoutineEditViewModel: MorningRoutineEditViewModelType {
    var inputs: MorningRoutineEditViewModelInputsType { return self }
    var outputs: MorningRoutineEditViewModelOutputsType { return self }
    var actions: MorningRoutineEditViewModelActionsType { return self }
    
    //Inputs
    var time: PublishSubject<TimeInterval>
    
    //Outputs
    var currentTime: Observable<TimeInterval>
    
    //Setup
    private let alarm: Alarm
    private let alarmService: AlarmServiceType
    private let coordinator: SceneCoordinatorType
    
    init(alarm: Alarm, serviceFactory: ServiceFactoryProtocol, coordinator: SceneCoordinatorType) {
        self.alarm = alarm
        self.alarmService = serviceFactory.createAlarm()
        self.coordinator = coordinator
        
        //Inputs
        time = PublishSubject()
        
        //Outputs
        currentTime = Observable.just(alarm.morningRoutine)
    }
    
    //Actions
    lazy var dismiss: Action<TimeInterval, Void> = { [weak self] this in
        return Action { time in
            self?.alarmService
            return self.coordinator.pop(animated: true)
        }
    }(self)
}

extension MorningRoutineEditViewModel: MorningRoutineEditViewModelInputsType, MorningRoutineEditViewModelOutputsType, MorningRoutineEditViewModelActionsType {}
