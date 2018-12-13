//
//  AppDelegate.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let appHasBeenStarted = false//UserDefaults.standard.bool(forKey: Constants.UserDefaults.AppHasBeenStarted)
        
        let alarmService = AlarmService()
        let coordinator = SceneCoordinator(window: window!)

        switch appHasBeenStarted {
        case true:
            let mainViewModel = MainViewModel(alarmService: alarmService)
            coordinator.transition(to: Scene.main(mainViewModel), withType: .root)
            
        case false:
            let weatherService = WeatherService()
            let calendarService = CalendarService()
            let routingService = RoutingService()
            let pages = createPages()
            let walkthroughViewModel = WalkthroughViewModel(pages: pages,
                                                            weatherService: weatherService,
                                                            routingService: routingService,
                                                            calendarService: calendarService,
                                                            alarmService: alarmService,
                                                            coordinator: coordinator)
            
            coordinator.transition(to: Scene.walkthrough(walkthroughViewModel), withType: .root)
        }
        
        
        return true
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

