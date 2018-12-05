//
//  MainViewModel.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol MainViewModelInputsType {
    
}

protocol MainViewModelOutputsType {
    var sections: Observable<[AlarmSectionModel]> { get }
}

protocol MainViewModelActionsType {
    
}

protocol MainViewModelType {
    var inputs : MainViewModelInputsType { get }
    var outputs : MainViewModelOutputsType { get }
    var actions : MainViewModelActionsType { get }
}

class MainViewModel: MainViewModelType {
    
    var inputs : MainViewModelInputsType { return self }
    var outputs : MainViewModelOutputsType { return self }
    var actions : MainViewModelActionsType { return self }
    
    //Outpus
    var sections: Observable<[AlarmSectionModel]>
    
    //Setup
    private let alarmService: AlarmServiceType

    init(alarmService: AlarmServiceType) {
        
        //Setup
        self.alarmService = alarmService
        let nextAlarm = alarmService.nextAlarm()
        
        //Inputs
        
        //Outputs
        sections = nextAlarm
            .map { SectionItem.alarmSectionItem(identity: "\($0.id)", date: $0.date) }
            .map { AlarmSectionModel.alarm(title: $0.identity, items: [$0]) }
            .map { [$0] }
        
    }
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
