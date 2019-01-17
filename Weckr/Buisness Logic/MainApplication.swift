//
//  MainApplication.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol MainApplicationProtocol {
    func start(window: UIWindow)
}

final class MainApplication: MainApplicationProtocol {
    
    private let viewModelFactory: ViewModelFactoryProtocol
    
    init(viewModelFactory: ViewModelFactoryProtocol) {
        self.viewModelFactory = viewModelFactory
    }
    
    //FIXME: - We need a new coordinator implementation where we dont need the window
    func start(window: UIWindow) {
        setupLogging()
        startCoordinator(window: window)
    }
    
    private func setupLogging() {
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
