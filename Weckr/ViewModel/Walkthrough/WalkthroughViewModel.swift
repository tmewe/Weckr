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
    private let locationManager = CLLocationManager()
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
         calendarService: CalendarServiceType) {
        
        //Setup
        self.weatherService = weatherService
        self.routingService = routingService
        self.calendarService = calendarService
        
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
        
        let vehicle = currentPageController
            .filter { $0.viewModel is TravelPageViewModel }
            .map { $0.viewModel.inputs.vehicle }
            .filterNil()
            .flatMap { $0 }
            .startWith(.car)
        
        //Time in seconds
        let morningRoutineTime = currentPageController
            .filter { $0.viewModel is MorningRoutinePageViewModel }
            .map { $0.viewModel.inputs.morningRoutineTime }
            .filterNil()
            .flatMap { $0 }
            .startWith(1)
        
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
            .filter { $0.0 < $0.1.count }
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
            .map { $0 + 1 }
            .withLatestFrom(slides) {($0, $1)}
            .filter { $0.0 == $0.1.count }
        
        //Alarm creation
        
        let events = calendarService.fetchEvents(at: Date(), calendars: nil)
        let firstEvent = events
            .map { $0.first }
            .filterNil()
        
        let startLocation = locationManager.rx.location
            .map { GeoCoordinate(lat: $0?.coordinate.latitude ?? 0, long: $0?.coordinate.longitude ?? 0) }
        let endLocation = firstEvent
            .map { $0.event.structuredLocation?.geoLocation?.coordinate }
            .filterNil()
            .map { ($0.latitude, $0.longitude) }
            .map(GeoCoordinate.init)
        let arrival = firstEvent.map { $0.event.startDate }.filterNil()
        
        let route = Observable.combineLatest(vehicle, startLocation, endLocation, arrival)
            .map(routingService.route)
            .flatMapLatest { $0 }
        
        let weatherForecast = startLocation
            .map(weatherService.forecast)
            .flatMapLatest { $0 }
        
        createTrigger
            .do(onNext: { _ in self.locationManager.startUpdatingLocation() })
            .withLatestFrom(firstEvent)
            .withLatestFrom(route) { ($0, $1) }
            .withLatestFrom(weatherForecast) { ($0.0, $0.1, $1) }
            .withLatestFrom(startLocation) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(events) { ($0.0, $0.1, $0.2, $0.3, $1) }
            .map(Alarm.init)
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}


