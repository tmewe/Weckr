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
import Action
import RxCoreLocation
import CoreLocation

protocol MainViewModelInputsType {
    var toggleRouteVisibility: PublishSubject<Void> { get }
    var viewWillAppear: PublishSubject<Void> { get }
    var createNewAlarm: PublishSubject<Void> { get }
}

protocol MainViewModelOutputsType {
    var sections: Observable<[AlarmSection]> { get }
    var dateString: Observable<String> { get }
    var dayString: Observable<String> { get }
    var errorOccurred: Observable<AppError?> { get }
}

protocol MainViewModelActionsType {
    var presentMorningRoutineEdit: CocoaAction { get }
    var presentTravelEdit: CocoaAction { get }
    var presentCalendarEdit: CocoaAction { get }
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
    var viewWillAppear: PublishSubject<Void>
    var createNewAlarm: PublishSubject<Void>
    
    //Outpus
    var sections: Observable<[AlarmSection]>
    var dateString: Observable<String>
    var dayString: Observable<String>
    var errorOccurred: Observable<AppError?>
    
    //Setup
    private let coordinator: SceneCoordinatorType
    private let serviceFactory: ServiceFactoryProtocol
    private let viewModelFactory: ViewModelFactoryProtocol
    private let alarmService: RealmServiceType
    private let userDefaults = UserDefaults.standard
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    init(serviceFactory: ServiceFactoryProtocol,
         viewModelFactory: ViewModelFactoryProtocol,
         coordinator: SceneCoordinatorType) {
        
        //Setup
        self.serviceFactory = serviceFactory
        self.viewModelFactory = viewModelFactory
        self.coordinator = coordinator
        self.alarmService = serviceFactory.createAlarm()
        let alarmUpdateService = serviceFactory.createAlarmUpdate()
        
        let alarmScheduler = serviceFactory.createAlarmScheduler()
        let authorizationService = serviceFactory.createAuthorizationStatus()
        let locationError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        let notificationError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        let calendarError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        
        let currentAlarm = alarmService.currentAlarmObservable().share(replay: 1, scope: .forever)
        
        let alarmItem = currentAlarm.filterNil()
            .map { [AlarmSectionItem.alarm(identity: "alarm", date: $0.date)] }
        let morningRoutineItem = currentAlarm.filterNil()
            .map { [AlarmSectionItem.morningRoutine(identity: "morningroutine", time: $0.morningRoutine)] }
        let eventItem = currentAlarm.filterNil()
            .map { [AlarmSectionItem.event(identity: "event",
                                      title: Strings.Cells.FirstEvent.title,
                                      selectedEvent: $0.selectedEvent)] }
        
        let currentLocation = locationManager.rx.location
            .filterNil()
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .map(GeoCoordinate.init)
            .share(replay: 1, scope: .forever)
        
        //Inputs
        toggleRouteVisibility = PublishSubject()
        viewWillAppear = PublishSubject()
        createNewAlarm = PublishSubject()
        let routeVisiblity: Observable<Bool> = toggleRouteVisibility
            .scan(false) { state, _ in  !state}
            .startWith(false)
            .share(replay: 1, scope: .forever)
        
        let routeOverviewItem = currentAlarm
            .filterNil()
            .map { alarm -> [AlarmSectionItem] in
                let leaveDate = alarm.selectedEvent.startDate - alarm.route.summary.trafficTime.seconds
                return [AlarmSectionItem.routeOverview(identity: "3", route: alarm.route, leaveDate: leaveDate)]
            }
        
        //Car route
        
        let routeItems: BehaviorSubject<[AlarmSectionItem]> = BehaviorSubject(value: [])
        
        let routeItemsExpanded = currentAlarm
            .filterNil()
            .map { alarm -> [AlarmSectionItem] in
                
                let route = alarm.route!
                let leaveDate = alarm.selectedEvent.startDate - alarm.route.summary.trafficTime.seconds
                var items = [AlarmSectionItem.routeOverview(identity: "3",
                                                       route: route,
                                                       leaveDate: leaveDate)]
                
                switch route.transportMode {
                case .car:
                    items.append(AlarmSectionItem.routeCar(identity: "4", route: route))
                    
                case .pedestrian, .transit:
                    
                    var maneuverDate = leaveDate //For transit departure and arrival
                    var skipNext = false
                    let maneuvers = route.legs.first!.maneuvers.dropLast()
                    for (index, maneuver) in maneuvers.enumerated() {
                        
                        guard !skipNext else {
                            skipNext = false
                            continue
                        }
                        
                        switch maneuver.transportType {
                            
                        case .privateTransport:
                            items.append(AlarmSectionItem.routePedestrian(
                                identity: maneuver.id,
                                maneuver: maneuver))
                            
                        case .publicTransport:
                            skipNext = true
                            let getOn = maneuver
                            let getOff = maneuvers[index + 1]
                            items.append(AlarmSectionItem.routeTransit(identity: maneuver.id,
                                                                  date: maneuverDate,
                                                                  getOn: getOn,
                                                                  getOff: getOff,
                                                                  transitLines: route.transitLines.toArray()))
                        }
                        
                        maneuverDate = maneuverDate + maneuver.travelTime.seconds
                    }
                }
                return items
        }
        
        let routeRefreshTrigger = Observable
            .combineLatest(routeVisiblity, currentAlarm) { visbility, _ in visbility }
            .share(replay: 1, scope: .forever)
        
        routeRefreshTrigger
            .filter { $0 }
            .withLatestFrom(routeItemsExpanded)
            .bind(to: routeItems)
            .disposed(by: disposeBag)
        
        routeRefreshTrigger
            .filter { !$0 }
            .withLatestFrom(routeOverviewItem)
            .bind(to: routeItems)
            .disposed(by: disposeBag)
        
        //Outputs
        sections = Observable.combineLatest(alarmItem,
                                            morningRoutineItem,
                                            routeItems,
                                            eventItem)
            .map { $0.0 + $0.1 + $0.2 + $0.3 }
            .map { [AlarmSection(header: "", items: $0)] }
            .startWith([])
        
        dateString = currentAlarm
            .map { $0?.date }
            .map { $0?.monthDayLong }
            .map { $0?.uppercased() }
            .replaceNilWith("")
        
        dayString = currentAlarm
            .map { $0?.date }
            .map { $0?.dayText }
            .replaceNilWith("No events found")
        
        //Location access status
        locationManager.rx.didChangeAuthorization
            .map { $0.1 }
            .map { status -> AppError? in
                switch status {
                case .restricted, .denied:
                    return AccessError.location
                default:
                    return nil
                }
            }
            .bind(to: locationError)
            .disposed(by: disposeBag)
        
        //Event store access status
        viewWillAppear
            .flatMapLatest { authorizationService.eventStoreAuthorization() }
            .bind(to: calendarError)
            .disposed(by: disposeBag)
        
        //Notification access status
        viewWillAppear
            .flatMapLatest { authorizationService.notificationAuthorization() }
            .bind(to: notificationError)
            .disposed(by: disposeBag)
        
        errorOccurred = Observable.combineLatest(locationError, notificationError, calendarError)
            .map { location, notification, event in
                if location != nil { return location }
                if notification != nil { return notification }
                if event != nil { return event }
                return nil
        }
        
        //User defaults
        //Morning routine
        userDefaults.rx.observe(TimeInterval.self, SettingsKeys.morningRoutineTime)
            .distinctUntilChanged()
            .filterNil()
            .withLatestFrom(currentAlarm.filterNil()) { ($0, $1) }
            .subscribe(onNext: alarmUpdateService.updateMorningRoutine)
            .disposed(by: disposeBag)
        
        //Transport mode
        userDefaults.rx.observe(Int.self, SettingsKeys.transportMode)
            .distinctUntilChanged()
            .filterNil()
            .map { TransportMode(mode: $0) }
            .withLatestFrom(currentAlarm.filterNil()) { ($0, $1) }
            .subscribe(onNext: { [weak self] mode, alarm in
                alarmUpdateService.updateTransportMode(mode,
                                                       for: alarm,
                                                       serviceFactory: serviceFactory,
                                                       disposeBag: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        // Notification for new alarm
        currentAlarm
            .filterNil()
            .map { $0.date }
            .subscribe(onNext: alarmScheduler.setAlarmNotification)
            .disposed(by: disposeBag)
        
        //Create new alarm (after notification)
        createNewAlarm.asObservable()
            .withLatestFrom(currentAlarm)
            .filter { $0 == nil }
            .withLatestFrom(currentLocation)
            .subscribe(onNext: { self.alarmService
                .createAlarmPrior(to: Date() + 1.weeks,
                                  startLocation: $0,
                                  serviceFactory: self.serviceFactory) })
            .disposed(by: disposeBag)
        
        //Update events on alarm date
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filterNil()
            .map { alarmUpdateService.updateEvents(for: $0,
                                                       serviceFactory: self.serviceFactory,
                                                       disposeBag: self.disposeBag) }
            .subscribe(onNext: { _ in print() })
            .disposed(by: disposeBag)
        
        //Check for events before next alarm
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filterNil()
            .filter { !$0.isInvalidated } //Needed if alarm gets deleted
            .map { $0.date }
            .withLatestFrom(currentLocation) { ($0, $1) }
            .flatMap { self.alarmService.createAlarmPrior(to: $0.0,
                                                          startLocation: $0.1,
                                                          serviceFactory: self.serviceFactory) }
            .subscribe(onNext: { _ in print("") })
            .disposed(by: disposeBag)
        
        //Create alarm if no alarm
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filter { $0 == nil }
            .withLatestFrom(currentLocation)
            .flatMap { self.alarmService
                .createFirstAlarm(startLocation: $0, serviceFactory: serviceFactory) }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
    
    //Actions
    
    lazy var presentMorningRoutineEdit: CocoaAction = {
        return CocoaAction {
            guard let alarm = self.alarmService.currentAlarm() else { return Observable.empty() }
            let viewModel = self.viewModelFactory
                .createMorningRoutineEdit(time: alarm.morningRoutine, coordinator: self.coordinator)
            return self.coordinator.transition(to: Scene.morningRoutingEdit(viewModel), withType: .modal)
        }
    }()
    
    lazy var presentTravelEdit: CocoaAction = {
        return CocoaAction {
            guard let alarm = self.alarmService.currentAlarm() else { return Observable.empty() }
            let viewModel = self.viewModelFactory
                .createTravelEdit(currentMode: alarm.route.transportMode, coordinator: self.coordinator)
            return self.coordinator.transition(to: Scene.travelEdit(viewModel), withType: .modal)
        }
    }()
    
    lazy var presentCalendarEdit: CocoaAction = {
        return CocoaAction {
            guard let alarm = self.alarmService.currentAlarm() else { return Observable.empty() }
            let viewModel = self.viewModelFactory.createCalendarEdit(alarm: alarm,
                                                                     coordinator: self.coordinator)
            return self.coordinator.transition(to: Scene.calendarEdit(viewModel), withType: .modal)
        }
    }()
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
