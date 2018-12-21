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
    var toggleRouteVisibility: PublishSubject<Void> { get }
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
    
    //Inputs
    var toggleRouteVisibility: PublishSubject<Void>
    
    //Outpus
    var sections: Observable<[AlarmSection]>
    var dateString: Observable<String>
    
    //Setup
    private let serviceFactory: ServiceFactoryProtocol
    private let disposeBag = DisposeBag()

    init(serviceFactory: ServiceFactoryProtocol) {
        
        //Setup
        self.serviceFactory = serviceFactory
        
        let alarmService = serviceFactory.createAlarm()
        let nextAlarm = alarmService.nextAlarm().share(replay: 1, scope: .forever)
        
        let alarmItem = nextAlarm.map { [SectionItem.alarm(identity: "1", date: $0.date)] }
        let morningRoutineItem = nextAlarm
            .map { [SectionItem.morningRoutine(identity: "2", time: $0.morningRoutine)] }
        let eventItem = nextAlarm
            .map { [SectionItem.event(identity: "7",
                                          title: "FIRST EVENT",
                                          selectedEvent: $0.selectedEvent)] }
        
        //Inputs
        toggleRouteVisibility = PublishSubject()
        let routeVisiblity: Observable<Bool> = toggleRouteVisibility
            .scan(false) { state, _ in  !state}
            .startWith(false)
            .share(replay: 1, scope: .forever)
        
        let routeOverviewItem = nextAlarm
            .map { [SectionItem.routeOverview(identity: "3", route: $0.route)] }
        
        let routeItemsExpanded = nextAlarm
            .map { [
                SectionItem.routeOverview(identity: "4", route: $0.route),
                SectionItem.routeOverview(identity: "5", route: $0.route),
                SectionItem.routeOverview(identity: "6", route: $0.route)
                ] }
        let routeItems: BehaviorSubject<[SectionItem]> = BehaviorSubject(value: [])
        
        routeVisiblity
            .filter { $0 }
            .withLatestFrom(routeItemsExpanded)
            .bind(to: routeItems)
            .disposed(by: disposeBag)
        
        routeVisiblity
            .filter { !$0 }
            .withLatestFrom(routeOverviewItem)
            .bind(to: routeItems)
            .disposed(by: disposeBag)
        
        //Outputs
        sections = Observable.combineLatest(alarmItem.debug(), morningRoutineItem.debug(), routeItems.debug(), eventItem.debug())
            .map { $0.0 + $0.1 + $0.2 + $0.3 }
            .map { [AlarmSection(header: "", items: $0)] }
            .startWith([])
        
        dateString = nextAlarm
            .map { $0.date }
            .map { $0.toFormat("EEEE, MMMM dd") }
            .map { $0.uppercased() }
    }
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
