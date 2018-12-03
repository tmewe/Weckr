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

protocol WalkthroughViewModelInputsType {
    var nextPage: PublishSubject<Void> { get }
    var previousPage: PublishSubject<Void> { get }
    var scrollAmount: PublishSubject<CGFloat> { get }
}

protocol WalkthroughViewModelOutputsType {
    var pageNumber : Observable<Int> { get }
    var slides : Observable<[WalkthroughPageViewController]> { get }
    var buttonColor: Observable<CGColor> { get }
    var buttonText: Observable<String> { get }
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
    private let weatherService: WeatherServiceType
    private let routingService: RoutingServiceType
    private let calendarService: CalendarServiceType
    private let alarmService: AlarmServiceType
    private let locationManager = CLLocationManager()
    private var coordinator: SceneCoordinatorType!
    private let disposeBag = DisposeBag()
    
    //Inputs
    var nextPage: PublishSubject<Void>
    var previousPage: PublishSubject<Void>
    var scrollAmount: PublishSubject<CGFloat>
    
    //Outputs
    var pageNumber: Observable<Int>
    var slides: Observable<[WalkthroughPageViewController]>
    var buttonColor: Observable<CGColor>
    var buttonText: Observable<String>
    
    init(pages: [WalkthroughPageViewController],
         weatherService: WeatherServiceType,
         routingService: RoutingServiceType,
         calendarService: CalendarServiceType,
         alarmService: AlarmServiceType,
         coordinator: SceneCoordinatorType) {
        
        //Setup
        locationManager.startUpdatingLocation()
        self.weatherService = weatherService
        self.routingService = routingService
        self.calendarService = calendarService
        self.alarmService = alarmService
        self.coordinator = coordinator
        
        //Inputs
        nextPage = PublishSubject()
        previousPage = PublishSubject()
        scrollAmount = PublishSubject()
        
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
        
        let createTrigger = nextPage
            .withLatestFrom(internalPageNumber)
            .withLatestFrom(slides) {($0, $1)}
            .filter { $0.0 == $0.1.count }
            .take(1)
            .share(replay: 1, scope: .forever)
        
        //Alarm creation
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents.init()
        dateComponents.day = 1
        let futureDate = calendar.date(byAdding: dateComponents, to: now)! // 1
        
        let events = createTrigger
            .map { _ in calendarService.fetchEvents(at: futureDate, calendars: nil) }
            .flatMapLatest { $0 }
            .share(replay: 1, scope: .forever)
        
        let startLocation = locationManager.rx.location
            .filterNil()
            .take(1)
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .map(GeoCoordinate.init)
            .share(replay: 1, scope: .forever)
        
        let weatherForecast = startLocation
            .map(weatherService.forecast)
            .flatMapLatest { $0 }
        
        let firstEvent = events
            .map { $0.first }
            .filterNil()
            .share(replay: 1, scope: .forever)
        
        let endLocation = firstEvent
            .map { $0.location }
            .filterNil()

        let arrival = firstEvent.map { $0.startDate }.filterNil()
        
        let vehiclePage = pages.filter { $0.viewModel is TravelPageViewModel }.first
        guard let vehicle = vehiclePage?.viewModel.inputs.vehicle else {
            return
        }
        
        let route = Observable.combineLatest(vehicle, startLocation, endLocation, arrival)
            .take(1)
            .flatMapLatest(routingService.route)
            .share(replay: 1, scope: .forever)
        
        let morningRoutinePage = pages.filter { $0.viewModel is MorningRoutinePageViewModel }.first
        guard let morningRoutineTime = morningRoutinePage?.viewModel.inputs.morningRoutineTime else {
            return
        }
        
        Observable.zip(createTrigger, route, weatherForecast) { ($1, $2) }
            .withLatestFrom(startLocation) { ($0.0, $0.1, $1) }
            .withLatestFrom(morningRoutineTime) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(firstEvent) { ($0.0, $0.1, $0.2, $0.3, $1) }
            .withLatestFrom(events) { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
            .take(1)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map(Alarm.init)
            .flatMap(alarmService.calculateDate)
            .map { alarmService.save(alarm: $0) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { coordinator.transition(to: Scene.main(MainViewModel()), withType: .modal) })
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}
