//
//  Strings.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

struct Strings {
    struct Walkthrough {
        
        struct Landing {
            static let title = "walkthrough.landing.title".localized
            static let titleColored = "walkthrough.landing.title.coloredPart".localized
            static let buttonTitle = "walkthrough.landing.buttonTitle".localized
        }
        
        struct Calendar {
            static let title = "walkthrough.calendar.title".localized
            static let titleColored = "walkthrough.calendar.title.coloredPart".localized
            static let subtitle = "walkthrough.calendar.title2".localized
            static let subtitleColored = "walkthrough.calendar.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.calendar.buttonTitle".localized
        }
        
        struct Location {
            static let title = "walkthrough.location.title".localized
            static let titleColored = "walkthrough.location.title.coloredPart".localized
            static let subtitle = "walkthrough.location.title2".localized
            static let subtitleColored = "walkthrough.location.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.location.buttonTitle".localized
        }
        
        struct Notification {
            static let title = "walkthrough.notification.title".localized
            static let titleColored = "walkthrough.notification.title.coloredPart".localized
            static let subtitle = "walkthrough.notification.title2".localized
            static let subtitleColored = "walkthrough.notification.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.notification.buttonTitle".localized
        }
        
        struct Travel {
            static let title = "walkthrough.travel.title".localized
            static let titleColored = "walkthrough.travel.title.coloredPart".localized
            static let subtitle = "walkthrough.travel.title2".localized
            static let subtitleColored = "walkthrough.travel.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.travel.buttonTitle".localized
        }
        
        struct MorningRoutine {
            static let title = "walkthrough.morningroutine.title".localized
            static let titleColored = "walkthrough.morningroutine.title.coloredPart".localized
            static let subtitle = "walkthrough.morningroutine.title2".localized
            static let subtitleColored = "walkthrough.morningroutine.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.morningroutine.buttonTitle".localized
        }
        
        struct Done {
            static let title = "walkthrough.done.title".localized
            static let titleColored = "walkthrough.done.title.coloredPart".localized
            static let subtitle = "walkthrough.done.title2".localized
            static let subtitleColored = "walkthrough.done.title2.coloredPart".localized
            static let buttonTitle = "walkthrough.done.buttonTitle".localized
        }
    }
    
    struct Main {
        static let today = "main.header.today".localized
        static let tomorrow = "main.header.tomorrow".localized
        static let dayAfterTomorrow = "main.header.dayaftertomorrow".localized
        
        struct Edit {
            static let morningRoutineTitle = "edit.morningRoutine".localized
            static let travelTitle = "edit.travel".localized
            static let done = "edit.done".localized
            static let clever = "edit.clever".localized
            static let firstEvent = "edit.firstEvent".localized
            static let alternativeEvent = "edit.alternativeEvent".localized
            static let adjustForWeather = "edit.adjustWeather".localized
            static let adjustForWeatherTitle = "edit.adjustWeather.title".localized
            static let adjustForWeatherInfo = "edit.adjustWeather.info".localized
        }
    }
    
    struct Directions {
        static let north = "direction.north".localized
        static let south = "direction.south".localized
        static let east = "direction.east".localized
        static let west = "direction.west".localized
        static let northWest = "direction.northWest".localized
        static let northEast = "direction.northEast".localized
        static let southWest = "direction.southWest".localized
        static let southEast = "direction.southEast".localized
        static let left = "direction.left".localized
        static let right = "direction.right".localized
        static let straight = "direction.straight".localized
        static let roundabout = "direction.roundabout".localized
        static let drive = "direction.drive".localized
    }
    
    struct Error {
        static let fixit = "error.fixit".localized
        static let undefinedTitle = "error.undefined.title".localized
        static let undefinedMessage = "error.undefined.message".localized
        
        struct Access {
            static let calendarTitle = "error.access.calendar.title".localized
            static let calendarMessage = "error.access.calendar.message".localized
            static let notificationTitle = "error.access.notification.title".localized
            static let notificationMessage = "error.access.notification.message".localized
            static let locationTitle = "error.access.location.title".localized
            static let locationMessage = "error.access.location.message".localized
        }
        
        struct Calendar {
            static let noEventsTitle = "error.calendar.noEvents.title".localized
            static let noEventsMessage = "error.calendar.noEvents.message".localized
        }
    }
}
