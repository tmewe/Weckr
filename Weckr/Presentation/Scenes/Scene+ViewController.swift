//
//  Scene+ViewController.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .main(let viewModel):
            let vc = MainViewController(viewModel: viewModel)
            return vc
        case .walkthrough(let viewModel):
            let vc = WalkthroughViewController(viewModel: viewModel)
            vc.bindViewModel()
            return vc
        case .morningRoutingEdit(let viewModel):
            let vc = MorningRoutineEditViewController(viewModel: viewModel)
            vc.bindViewModel()
            return vc
        case .calendarEdit(let viewModel):
            let vc = CalendarEditViewController(viewModel: viewModel)
            return vc
        case .travelEdit(let viewModel):
            let vc = TravelEditViewController(viewModel: viewModel)
            vc.bindViewModel()
            return vc
        }
    }
}
