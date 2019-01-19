//
//  DependencyContainer.swift
//  Weckr
//
//  Created by Tim Mewe on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func createMain(coordinator: SceneCoordinatorType) -> MainViewModelType
    func createWalkthrough(with pages: [WalkthroughPageViewController],
                           coordinator: SceneCoordinatorType) -> WalkthroughViewModelType
    func createMorningRoutineEdit(time: TimeInterval, coordinator: SceneCoordinatorType)
        -> MorningRoutineEditViewModelType
    func createCalendarEdit(alarm: Alarm, coordinator: SceneCoordinatorType)
        -> CalendarEditViewModelType
    func createTravelEdit(currentMode: TransportMode, coordinator: SceneCoordinatorType)
        -> TravelEditViewModelType
}

protocol ServiceFactoryProtocol {
    func createWeather() -> WeatherServiceType
    func createRouting() -> RoutingServiceType
    func createCalendar() -> CalendarServiceType
    func createRealm() -> RealmServiceType
    func createGeocoder() -> GeocodingServiceType
    func createAuthorizationStatus() -> AuthorizationStatusServiceType
    func createAlarmScheduler() -> AlarmSchedulerServiceType
    func createAlarmUpdate() -> AlarmUpdateService
}

final class DependencyContainer {
    private lazy var mainApplication: MainApplicationProtocol = MainApplication(
        viewModelFactory: self,
        serviceFactory: self
    )
}

extension DependencyContainer {
    func buildApplication() -> MainApplicationProtocol {
        return mainApplication
    }
}

extension DependencyContainer: ViewModelFactoryProtocol {
    func createMain(coordinator: SceneCoordinatorType) -> MainViewModelType {
        return MainViewModel(serviceFactory: self, viewModelFactory: self, coordinator: coordinator)
    }
    
    func createWalkthrough(with pages: [WalkthroughPageViewController],
                           coordinator: SceneCoordinatorType) -> WalkthroughViewModelType {
        return WalkthroughViewModel(pages: pages,
                                    viewModelFactory: self,
                                    serviceFactory: self,
                                    coordinator: coordinator)
    }
    
    func createMorningRoutineEdit(time: TimeInterval, coordinator: SceneCoordinatorType)
        -> MorningRoutineEditViewModelType {
            return MorningRoutineEditViewModel(morningRoutine: time,
                                               coordinator: coordinator)
    }
    
    func createCalendarEdit(alarm: Alarm,
                            coordinator: SceneCoordinatorType) -> CalendarEditViewModelType {
        return CalendarEditViewModel(alarm: alarm, serviceFactory: self, coordinator: coordinator)
    }
    
    func createTravelEdit(currentMode: TransportMode,
                          coordinator: SceneCoordinatorType) -> TravelEditViewModelType {
        return TravelEditViewModel(mode: currentMode, coordinator: coordinator)
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
    
    func createRealm() -> RealmServiceType {
        return RealmService()
    }
    
    func createGeocoder() -> GeocodingServiceType {
        return GeocodingService()
    }
    
    func createAuthorizationStatus() -> AuthorizationStatusServiceType {
        return AuthorizationStatusService()
    }
    
    func createAlarmScheduler() -> AlarmSchedulerServiceType {
        return AlarmSchedulerService()
    }
    
    func createAlarmUpdate() -> AlarmUpdateService {
        return AlarmUpdateService()
    }
}
