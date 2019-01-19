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
    private lazy var dependencyContainer = DependencyContainer()
    private var mainApplication: MainApplicationProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainApplication = dependencyContainer.buildApplication()
        mainApplication.start(window: window!)
        return true
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        mainApplication.application(application, performFetchWithCompletionHandler: completionHandler)
    }
}

