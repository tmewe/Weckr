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
        // Override point for customization after application launch.
        
        let pages = createPages()
        let coordinator = SceneCoordinator(window: window!)
        let walkthroughViewModel = WalkthroughViewModel(pages: pages)
        coordinator.transition(to: Scene.walkthrough(walkthroughViewModel), withType: .root)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

