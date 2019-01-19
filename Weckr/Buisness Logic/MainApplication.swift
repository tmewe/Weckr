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

protocol MainApplicationProtocol {
    func start(window: UIWindow)
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

final class MainApplication: NSObject, MainApplicationProtocol {
    
    private let viewModelFactory: ViewModelFactoryProtocol
    private let serviceFactory: ServiceFactoryProtocol
    private var locationManager: CLLocationManager?
    private var currentLocation: GeoCoordinate?
    
    init(viewModelFactory: ViewModelFactoryProtocol,
         serviceFactory: ServiceFactoryProtocol) {
        self.viewModelFactory = viewModelFactory
        self.serviceFactory = serviceFactory
    }
    
    //FIXME: - We need a new coordinator implementation where we dont need the window
    func start(window: UIWindow) {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    
        setupLogging()
        setupLocationManager()
        startCoordinator(window: window)
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let started = UserDefaults.standard.bool(forKey: SettingsKeys.appHasBeenStarted)
        guard started else { return }
        
        locationManager?.requestAlwaysAuthorization()
        
        let realmService = serviceFactory.createRealm()
        
        //Create alarm if there is no current alarm
        let currentAlarm = realmService.currentAlarm()
        guard currentAlarm != nil else {
//            realmService.createFirstAlarm(startLocation: , serviceFactory: dependencyContainer)
            completionHandler(.newData)
            return
        }
        
        print(currentLocation)
        
        //Update events on current alarm
        
        //Check for events on prior dates
        
        //Check location and update route for current alarm
    }
    
    private func setupLogging() {
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
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

extension MainApplication: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        currentLocation = GeoCoordinate(location: mostRecentLocation)
    }
}
