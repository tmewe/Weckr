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
    var time: PublishSubject<TimeIntervall> { get }
}

protocol MorningRoutineEditViewModelOutputsType {}

protocol MorningRoutineEditViewModelActionsType {
    var dismiss: CocoaAction { get }
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
    
    //Outputs
    
    //Setup
    private let coordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.coordinator = coordinator
    }
    
    //Actions
    lazy var dismiss: CocoaAction = {
        return CocoaAction {
            return self.coordinator.pop(animated: true)
        }
    }()
}

extension MorningRoutineEditViewModel: MorningRoutineEditViewModelInputsType, MorningRoutineEditViewModelOutputsType, MorningRoutineEditViewModelActionsType {}
