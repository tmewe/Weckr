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
     var showAlert: Observable<AlertInfo> { get }
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
    var showAlert: Observable<AlertInfo>
    
    //Setup
    private let coordinator: SceneCoordinatorType
    private let serviceFactory: ServiceFactoryProtocol
    private let viewModelFactory: ViewModelFactoryProtocol
    private let alarmService: RealmServiceType
    private let alarmSectionService: AlarmSectionServiceType
    private let userDefaults = UserDefaults.standard
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    init(serviceFactory: ServiceFactoryProtocol,
         viewModelFactory: ViewModelFactoryProtocol,
         coordinator: SceneCoordinatorType) {
        
        //Setup
        locationManager.startUpdatingLocation()
        self.serviceFactory = serviceFactory
        self.viewModelFactory = viewModelFactory
        self.coordinator = coordinator
        self.alarmService = serviceFactory.createRealm()
        self.alarmSectionService = serviceFactory.createAlarmSection()
        let alarmUpdateService = serviceFactory.createAlarmUpdate()
        
        let alarmScheduler = serviceFactory.createAlarmScheduler()
        let authorizationService = serviceFactory.createAuthorizationStatus()
        let locationError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        let notificationError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        let calendarError: BehaviorSubject<AppError?> = BehaviorSubject(value: nil)
        let alertInfo: PublishSubject<AlertInfo> = PublishSubject()
        
        let currentAlarm = alarmService.currentAlarmObservable().share(replay: 1, scope: .forever)
        
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
        
        //Route
        let alarmItem = alarmSectionService.alarmItem(for: currentAlarm)
        let morningRoutineItem = alarmSectionService.morningRoutineItem(for: currentAlarm)
        let routeOverviewItem = alarmSectionService.routeOverviewItem(for: currentAlarm)
        let routeItemsExpanded = alarmSectionService.allRouteItems(for: currentAlarm)
        let eventItem = alarmSectionService.eventItem(for: currentAlarm)
        let routeItems: BehaviorSubject<[AlarmSectionItem]> = BehaviorSubject(value: [])
        
        let routeRefreshTrigger = Observable
            .combineLatest(routeVisiblity, currentAlarm) { visbility, _ in visbility }
            .share(replay: 1, scope: .forever)
        
        Observable.combineLatest(routeRefreshTrigger, routeItemsExpanded)
            .filter { $0.0 }
            .map { $0.1 }
            .bind(to: routeItems)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(routeRefreshTrigger, routeOverviewItem)
            .filter { $0.0 == false }
            .map { $0.1 }
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
        
        showAlert = alertInfo.asObservable()
        
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
                .createFirstAlarm(startLocation: $0, serviceFactory: serviceFactory) })
            .disposed(by: disposeBag)
        
        //Update events on current alarm date
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filterNil()
            .map { alarmUpdateService.updateEvents(for: $0,
                                                       serviceFactory: self.serviceFactory,
                                                       disposeBag: self.disposeBag) }
            .subscribe(onNext: { _ in print() })
            .disposed(by: disposeBag)
        
        //Check for events before current alarm
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filterNil()
            .filter { !$0.isInvalidated } //Needed if alarm gets deleted
            .map { $0.date }
            .withLatestFrom(currentLocation) { ($0, $1) }
            .flatMap { self.alarmService.createAlarmPrior(to: $0.0,
                                                          startLocation: $0.1,
                                                          serviceFactory: self.serviceFactory) }
            .subscribe(onNext: { result in
                print(result)
//                if case .Failure(let error) = result {
//                    let info = AlertInfo(title: error.localizedTitle,
//                                         message: error.localizedMessage,
//                                         button: Strings.Error.gotit)
//                    alertInfo.onNext(info)
//                }
            })
            .disposed(by: disposeBag)
        
        //Create alarm if no alarm
        viewWillAppear
            .withLatestFrom(currentAlarm)
            .filter { $0 == nil }
            .withLatestFrom(currentLocation)
            .flatMap { self.alarmService
                .createFirstAlarm(startLocation: $0, serviceFactory: serviceFactory) }
            .subscribe(onNext: { result in
                if case .Failure(let error) = result {
                    let info = AlertInfo(title: error.localizedTitle,
                                         message: error.localizedMessage,
                                         button: Strings.Error.gotit)
                    alertInfo.onNext(info)
                }
            })
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
