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

struct EventEditWrapper {
    var event: CalendarEntry
    var description: String
    var selected: Bool
    var gradient: Gradient {
        if selected {
            return Gradient(left: UIColor.eventCellLeft.cgColor,
                     right: UIColor.eventCellRight.cgColor)
        }
        return Gradient(left: UIColor.eventEditCellLeft.cgColor,
                 right: UIColor.eventEditCellRight.cgColor)
    }
}

typealias EventsSection = SectionModel<String, EventEditWrapper>

protocol CalendarEditViewModelInputsType {}

protocol CalendarEditViewModelOutputsType {
    var events: Observable<[EventsSection]> { get }
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
    
    //Inputs
    var selectedEvent: PublishSubject<EventEditWrapper>
    
    //Outputs
    var events: Observable<[EventsSection]>
    
    //Setup
    private let alarm: Alarm
    private let serviceFactory: ServiceFactoryProtocol
    private let alarmService: AlarmServiceType
    private let coordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    init(alarm: Alarm, serviceFactory: ServiceFactoryProtocol, coordinator: SceneCoordinatorType) {
        self.alarm = alarm
        self.serviceFactory = serviceFactory
        self.alarmService = serviceFactory.createAlarm()
        self.coordinator = coordinator
        
        //Inputs
        selectedEvent = PublishSubject()
        
        //Outputs
        events = Observable.just(alarm.otherEvents.toArray())
            .map { events in
                return events.map { event in
                    
                    var desc = Strings.Main.Edit.alternativeEvent
                    var selected = false
                    
                    if event == alarm.selectedEvent {
                        desc = Strings.Main.Edit.firstEvent
                        selected = true
                    }
                    
                   return EventEditWrapper(event: event, description: desc, selected: selected)
                }
            }
            .map { [EventsSection(model: "Events", items: $0)] }
    }
    
    //Actions
    lazy var dismiss: Action<EventEditWrapper, Void> = { [weak self] this in
        return Action { wrapper in
            this.alarmService.update(alarm: this.alarm,
                                with: wrapper.event,
                                serviceFactory: this.serviceFactory,
                                disposeBag: this.disposeBag)
            return this.coordinator.pop(animated: true)
        }
    }(self)
}

extension CalendarEditViewModel: CalendarEditViewModelInputsType, CalendarEditViewModelOutputsType, CalendarEditViewModelActionsType {}
