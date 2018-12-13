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
import SwiftDate

protocol MainViewModelInputsType {
    
}

protocol MainViewModelOutputsType {
    var sections: Observable<[AlarmSection]> { get }
    var dateString: Observable<String> { get }
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
    var sections: Observable<[AlarmSection]>
    var dateString: Observable<String>
    
    //Setup
    private let alarmService: AlarmServiceType

    init(alarmService: AlarmServiceType) {
        
        //Setup
        self.alarmService = alarmService
        let nextAlarm = alarmService.nextAlarm().share(replay: 1, scope: .forever)
        
        //Inputs
        
        //Outputs
        sections = nextAlarm
            .map { [
                SectionItem.alarmSectionItem(identity: "\($0.id)", date: $0.date),
                SectionItem.morningRoutineSectionItem(identity: "\($0.morningRoutine)", time: $0.morningRoutine)
                ]
            }
            .map { [AlarmSection(header: "", items: $0)] }
        
        dateString = nextAlarm
            .map { $0.date }
            .map { $0.toFormat("EEEE, MMMM dd") }
    }
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
