//
//  Scene.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

enum Scene {
    case main(MainViewModelType)
    case walkthrough(WalkthroughViewModelType)
    case morningRoutingEdit(MorningRoutineEditViewModelType)
    case calendarEdit(CalendarEditViewModelType)
    case travelEdit(TravelEditViewModelType)
}
