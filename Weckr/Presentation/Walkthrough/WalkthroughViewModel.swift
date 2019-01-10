//
//  WalkthroughViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 03.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import RxCoreLocation
import CoreLocation
import SwiftDate

protocol WalkthroughViewModelInputsType {
    var nextPage: PublishSubject<Void> { get }
    var previousPage: PublishSubject<Void> { get }
    var scrollAmount: PublishSubject<CGFloat> { get }
    var viewWillAppear: PublishSubject<Void> { get }
}

protocol WalkthroughViewModelOutputsType {
    var pageNumber : Observable<Int> { get }
    var slides : Observable<[WalkthroughPageViewController]> { get }
    var buttonColor: Observable<CGColor> { get }
    var buttonText: Observable<String> { get }
    var createTrigger: Observable<Void> { get }
    var errorOccurred: Observable<Error?> { get }
}

protocol WalkthroughViewModelType {
    var inputs : WalkthroughViewModelInputsType { get }
    var outputs : WalkthroughViewModelOutputsType { get }
}

class WalkthroughViewModel: WalkthroughViewModelType {
    
    var inputs: WalkthroughViewModelInputsType { return self }
    var outputs: WalkthroughViewModelOutputsType { return self }
    
    //Setup
    private var internalPageNumber = BehaviorSubject(value: 0)
    private var internalButtonColor = BehaviorSubject(value: UIColor.walkthroughPurpleAccent.cgColor)
    
    private var locationError: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
    private var notificationError: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
    private var calendarError: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
    
    private let serviceFactory: ServiceFactoryProtocol
    private let viewModelFactory: ViewModelFactoryProtocol
    private let locationManager = CLLocationManager()
    private var coordinator: SceneCoordinatorType!
    private let disposeBag = DisposeBag()
    
    //Inputs
    var nextPage: PublishSubject<Void>
    var previousPage: PublishSubject<Void>
    var scrollAmount: PublishSubject<CGFloat>
    var viewWillAppear: PublishSubject<Void>
    
    //Outputs
    var pageNumber: Observable<Int>
    var slides: Observable<[WalkthroughPageViewController]>
    var buttonColor: Observable<CGColor>
    var buttonText: Observable<String>
    var createTrigger: Observable<Void>
    var errorOccurred: Observable<Error?>
    
    init(pages: [WalkthroughPageViewController],
         viewModelFactory: ViewModelFactoryProtocol,
         serviceFactory: ServiceFactoryProtocol,
         coordinator: SceneCoordinatorType) {
        
        //Setup
        self.coordinator = coordinator
        self.viewModelFactory = viewModelFactory
        self.serviceFactory = serviceFactory
        
        let alarmService = serviceFactory.createAlarm()
        let authorizationService = serviceFactory.createAuthorizationStatus()
        
        locationManager.startUpdatingLocation()
        
        //Inputs
        nextPage = PublishSubject()
        previousPage = PublishSubject()
        scrollAmount = PublishSubject()
        viewWillAppear = PublishSubject()
        
        //Outputs
        pageNumber = internalPageNumber.asObservable()
        slides = Observable.of(pages)
        
        let currentPageController = scrollAmount
            .withLatestFrom(slides) { ($0, $1) }
            .map { $0.1[Int(floor($0.0))] }
            .startWith(pages.first)
            .distinctUntilChanged()
            .filterNil()
            .share()
        
        buttonColor = currentPageController
            .map { $0.viewModel.outputs.accentColor }
            .flatMap { $0 }
            .startWith(UIColor.walkthroughPurpleAccent.cgColor)

        buttonText = currentPageController
            .map { $0.viewModel.outputs.buttonText }
            .flatMap { $0 }
        
        nextPage
            .withLatestFrom(internalPageNumber)
            .map { $0 + 1 }
            .withLatestFrom(slides) {($0, $1)}
            .filter { $0.0 <= $0.1.count }
            .map { $0.0 }
            .bind(to: internalPageNumber)
            .disposed(by: disposeBag)
        
        previousPage
            .withLatestFrom(internalPageNumber)
            .map { $0 - 1 }
            .filter { $0 >= 0 }
            .bind(to: internalPageNumber)
            .disposed(by: disposeBag)
        
        nextPage
            .withLatestFrom(currentPageController)
            .subscribe(onNext: { $0.viewModel.actions.continueAction?.execute(Void()) })
            .disposed(by: disposeBag)
        
        createTrigger = nextPage
            .withLatestFrom(internalPageNumber)
            .withLatestFrom(slides) {($0, $1)}
            .filter { $0.0 == $0.1.count }
            .map { _ in }
            .take(1)
            .share(replay: 1, scope: .forever)
        
        let triggerViewModel = internalPageNumber
            .filter { $0 > 1 }
            .map { pages[$0-1].viewModel }
            .share(replay: 1, scope: .forever)
        
        let notificationTrigger = triggerViewModel
            .filter { $0 is NotificationPageViewModel }
            .take(1)
        
        let calendarTrigger = triggerViewModel
            .filter { $0 is CalendarPageViewModel }
            .take(1)
        
        let startLocation = locationManager.rx.location
            .filterNil()
            .take(1)
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .map(GeoCoordinate.init)
            .share(replay: 1, scope: .forever)
        
        //Location status
        locationManager.rx.didChangeAuthorization
            .map { $0.1 }
            .map { status -> Error? in
                switch status {
                case .restricted, .denied:
                    return AccessError.location
                default:
                    return nil
                }
            }
            .bind(to: locationError)
            .disposed(by: disposeBag)
        
        //Notification status
        let notificationPage = pages.filter { $0.viewModel is NotificationPageViewModel }.first
        notificationPage!.viewModel.outputs.actionSuccesful
//            .debug("notification action", trimOutput: true)
            .map { $0 ? nil : AccessError.notification }
            .bind(to: notificationError)
            .disposed(by: disposeBag)
        
        viewWillAppear
            .skipUntil(notificationTrigger)
            .flatMapLatest { authorizationService.notificationAuthorization() }
//            .debug("notification", trimOutput: true)
            .bind(to: notificationError)
            .disposed(by: disposeBag)
        
        //Event status
        let eventPage = pages.filter { $0.viewModel is CalendarPageViewModel }.first
        eventPage!.viewModel.outputs.actionSuccesful
//            .debug("calendar action", trimOutput: true)
            .map { $0 ? nil : AccessError.calendar }
            .bind(to: calendarError)
            .disposed(by: disposeBag)
        
        viewWillAppear
            .skipUntil(calendarTrigger)
            .flatMapLatest { authorizationService.eventStoreAuthorization() }
//            .debug("calendar", trimOutput: true)
            .bind(to: calendarError)
            .disposed(by: disposeBag)
        
        errorOccurred = Observable.combineLatest(locationError, notificationError, calendarError)
//            .debug("errorOccurred", trimOutput: true)
            .map { location, notification, event in
                if location != nil { return location }
                if notification != nil { return notification }
                if event != nil { return event }
                return nil
            }
        
        let vehiclePage = pages.filter { $0.viewModel is TravelPageViewModel }.first
        guard let vehicle = vehiclePage?.viewModel.inputs.transportMode else {
            return
        }
        
        let morningRoutinePage = pages.filter { $0.viewModel is MorningRoutinePageViewModel }.first
        guard let morningRoutineTime = morningRoutinePage?.viewModel.inputs.morningRoutineTime else {
            return
        }
        
        createTrigger
            .withLatestFrom(vehicle)
            .withLatestFrom(morningRoutineTime) {      ($0, $1) }
            .withLatestFrom(startLocation) {   ($0.0, $0.1, $1) }
            .flatMapLatest {
                alarmService.createAlarm(vehicle: $0.0,
                                         morningRoutineTime: $0.1,
                                         startLocation: $0.2,
                                         serviceFactory: serviceFactory) }
            .subscribe(onNext: { _ in
                coordinator.transition(to: Scene.main(viewModelFactory
                    .createMain(coordinator: coordinator)),
                                       withType: .modal)
                UserDefaults.standard.set(true, forKey: SettingsKeys.appHasBeenStarted)
            })
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}
