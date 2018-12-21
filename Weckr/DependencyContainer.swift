//
//  DependencyContainer.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func createMain() -> MainViewModelType
    func createWalkthrough(with pages: [WalkthroughPageViewController],
                           coordinator: SceneCoordinatorType) -> WalkthroughViewModelType
}

protocol ServiceFactoryProtocol {
    func createWeather() -> WeatherServiceType
    func createRouting() -> RoutingServiceType
    func createCalendar() -> CalendarServiceType
    func createAlarm() -> AlarmServiceType
}

final class DependencyContainer {
    private lazy var mainApplication: MainApplicationProtocol = MainApplication(
        viewModelFactory: self
    )
}

extension DependencyContainer {
    func buildApplication() -> MainApplicationProtocol {
        return mainApplication
    }
}

extension DependencyContainer: ViewModelFactoryProtocol {
    func createMain() -> MainViewModelType {
        return MainViewModel(serviceFactory: self)
    }
    
    func createWalkthrough(with pages: [WalkthroughPageViewController],
                           coordinator: SceneCoordinatorType) -> WalkthroughViewModelType {
        return WalkthroughViewModel(pages: pages,
                                    viewModelFactory: self,
                                    serviceFactory: self,
                                    coordinator: coordinator)
    }
}

extension DependencyContainer: ServiceFactoryProtocol {
    func createWeather() -> WeatherServiceType {
        return WeatherService()
    }
    
    func createRouting() -> RoutingServiceType {
        return RoutingService()
    }
    
    func createCalendar() -> CalendarServiceType {
        return CalendarService()
    }
    
    func createAlarm() -> AlarmServiceType {
        return AlarmService()
    }
}
