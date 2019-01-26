//
//  MainApplication.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import SwiftyBeaver

let log = SwiftyBeaver.self

protocol MainApplicationProtocol {
    func start(window: UIWindow)
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

final class MainApplication: NSObject, MainApplicationProtocol {
    
    private let viewModelFactory: ViewModelFactoryProtocol
    private let serviceFactory: ServiceFactoryProtocol
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    init(viewModelFactory: ViewModelFactoryProtocol,
         serviceFactory: ServiceFactoryProtocol) {
        self.viewModelFactory = viewModelFactory
        self.serviceFactory = serviceFactory
    }
    
    //FIXME: - We need a new coordinator implementation where we dont need the window
    func start(window: UIWindow) {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    
        setupLogging()
        startCoordinator(window: window)
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let backgroundService = serviceFactory.createBackground()
        let realmService = serviceFactory.createRealm()
        let updateService = serviceFactory.createAlarmUpdate()
        let schedulerService = serviceFactory.createAlarmScheduler()
        
        let started = UserDefaults.standard.bool(forKey: SettingsKeys.appHasBeenStarted)
        guard started else { return }
        
        let currentLocation = locationManager.rx.location
            .filterNil()
            .map { ($0.coordinate.latitude, $0.coordinate.longitude) }
            .map(GeoCoordinate.init)
            .share(replay: 1, scope: .forever)
        
        let currentAlarm = realmService.currentAlarm()

        //Create alarm if there is no current alarm
        if currentAlarm == nil {
            Observable.just(currentAlarm)
                .withLatestFrom(Observable.just(currentLocation))
                .withLatestFrom(Observable.just(realmService)) { ($0, $1) }
                .withLatestFrom(Observable.just(serviceFactory)) { ($0.0, $0.1, $1) }
                .flatMapLatest(backgroundService.createFirstAlarm)
                .subscribe(onNext: { result in
                    switch result {
                    case .Success(_):
                        completionHandler(.newData)
                    case .Failure(_):
                        //Send notification
                        schedulerService.setNoAlarmNotification()
                        completionHandler(.noData)
                    }
                })
                .disposed(by: disposeBag)
        } else {
            //Update events on current alarm date
            let current = backgroundService.updateCurrent(alarm: currentAlarm,
                                                          updateService: updateService,
                                                          serviceFactory: serviceFactory)
            
            //Check for events before current alarm
            let prior = backgroundService.updateEventsPrior(to: currentAlarm,
                                                            location: currentLocation,
                                                            realmService: realmService,
                                                            serviceFactory: serviceFactory)
            
            //Check location and update route for current alarm
            let location = currentLocation
                .withLatestFrom(Observable.just(currentAlarm).filterNil()) { ($0, $1) }
                .withLatestFrom(Observable.just(updateService)) { ($0.0, $0.1, $1) }
                .withLatestFrom(Observable.just(serviceFactory)) { ($0.0, $0.1, $0.2, $1) }
                .flatMapLatest(backgroundService.updateUserLocation)
            
            //Delete all past
            let deletePast = realmService.deletePastAlarms()
            
            Observable.combineLatest(current, prior, location, deletePast)
                .subscribe(onNext: { _ in completionHandler(.newData)} )
                .disposed(by: disposeBag)
        }
    }
    
    private func setupLogging() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss.SSS$d $C$L$c\t$N[$l] $F - $M"
        console.minLevel = .verbose
        log.addDestination(console)
    }
    
    private func startCoordinator(window: UIWindow) {
        let appHasBeenStarted = UserDefaults
            .standard
            .bool(forKey: SettingsKeys.appHasBeenStarted)
    
        let coordinator = SceneCoordinator(window: window)
        
        switch appHasBeenStarted {
        case true:
            coordinator.transition(to: Scene.main(viewModelFactory.createMain(coordinator: coordinator)),
                                   withType: .root)
            
        case false:
            let pages = createPages()
            let walkthroughViewModel = viewModelFactory.createWalkthrough(with: pages,
                                                                          coordinator: coordinator)
            
            coordinator.transition(to: Scene.walkthrough(walkthroughViewModel), withType: .root)
        }
    }
    
    private func createPages() -> [WalkthroughPageViewController] {
        let landingViewModel = LandingPageViewModel()
        let landingPage = WalkthroughPageViewController(viewModel: landingViewModel)
        let calendarViewModel = CalendarPageViewModel()
        let calendarPage = WalkthroughPageViewController(viewModel: calendarViewModel)
        let locationViewModel = LocationPageViewModel()
        let locationPage = WalkthroughPageViewController(viewModel: locationViewModel)
        let notificationViewModel = NotificationPageViewModel()
        let notificationPage = WalkthroughPageViewController(viewModel: notificationViewModel)
        let travelViewModel = TravelPageViewModel()
        let travelPage = WalkthroughPageViewController(viewModel: travelViewModel)
        let routineViewModel = MorningRoutinePageViewModel()
        let routinePage = WalkthroughPageViewController(viewModel: routineViewModel)
        let doneViewModel = DonePageViewModel()
        let donePage = WalkthroughPageViewController(viewModel: doneViewModel)
        
        let pages = [landingPage, calendarPage, locationPage,
                     notificationPage, travelPage, routinePage, donePage]
        return pages
    }
}
