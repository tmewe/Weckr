//
//  CalendarEditViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import Action


protocol CalendarEditViewModelInputsType {}

protocol CalendarEditViewModelOutputsType {
    var events: Observable<[CalendarEditSection]> { get }
}

protocol CalendarEditViewModelActionsType {
    var dismiss: Action<EventEditWrapper, Void> { get }
}

protocol CalendarEditViewModelType {
    var inputs: CalendarEditViewModelInputsType { get }
    var outputs: CalendarEditViewModelOutputsType { get }
    var actions: CalendarEditViewModelActionsType { get }
}

class CalendarEditViewModel: CalendarEditViewModelType {
    var inputs: CalendarEditViewModelInputsType { return self }
    var outputs: CalendarEditViewModelOutputsType { return self }
    var actions: CalendarEditViewModelActionsType { return self }
    
    //Outputs
    var events: Observable<[CalendarEditSection]>
    
    //Setup
    private let alarm: Alarm
    private let serviceFactory: ServiceFactoryProtocol
    private let realmService: RealmServiceType
    private let coordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    init(alarm: Alarm, serviceFactory: ServiceFactoryProtocol, coordinator: SceneCoordinatorType) {
        self.alarm = alarm
        self.serviceFactory = serviceFactory
        self.realmService = serviceFactory.createRealm()
        self.coordinator = coordinator
        
        //Outputs
        let title = Observable.just([
            CalendarEditSectionItem.title(text: Strings.Main.Edit.calendarTitle,
                                          coloredPart: Strings.Main.Edit.calendarTitleColoredPart)
            ])
        
        let eventItems: Observable<[CalendarEditSectionItem]> =
            Observable.just(alarm.otherEvents.toArray())
            .map { events in
                return events.map { event in
                    
                    var desc = Strings.Main.Edit.alternativeEvent
                    var selected = false
                    
                    if event == alarm.selectedEvent {
                        desc = Strings.Main.Edit.firstEvent
                        selected = true
                    }
                    
                   let wrapper = EventEditWrapper(event: event, description: desc, selected: selected)
                    return CalendarEditSectionItem.calendarItem(event: wrapper)
                }
            }
        
        events = Observable
            .combineLatest(title, eventItems)
            .map { $0.0 + $0.1 }
            .map { [CalendarEditSection(header:"", items: $0)] }

    }
    
    //Actions
    lazy var dismiss: Action<EventEditWrapper, Void> = { [weak self] this in
        return Action { wrapper in
            guard wrapper.event != this.alarm.selectedEvent else {
                return this.coordinator.pop(animated: true)
            }
            
            return this.realmService.update(selectedEvent: wrapper.event, for: this.alarm)
                .flatMapLatest { _ in this.coordinator.pop(animated: true) }
        }
    }(self)
}

extension CalendarEditViewModel: CalendarEditViewModelInputsType, CalendarEditViewModelOutputsType, CalendarEditViewModelActionsType {}
