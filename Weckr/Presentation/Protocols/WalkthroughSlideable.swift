//
//  WalkthroughSlideWrapper.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit.UIView
import UIKit.UIColor
import RxSwift
import Action

public enum Vehicle: Int {
    case car
    case feet
    case transit
}

protocol WalkthroughSlideableInputsType {
    var transportMode: PublishSubject<TransportMode>? { get }
    var morningRoutineTime: PublishSubject<TimeInterval>? { get } //Seconds
}
    
protocol WalkthroughSlideableOutputsType {
    var accentColor: Observable<CGColor> { get }
    var buttonText: Observable<String> { get }
    var topLabelText: Observable<String> { get }
    var topLabelColoredText: Observable<String> { get }
    var bottomLabelText: Observable<String> { get }
    var bottomLabelColoredText: Observable<String> { get }
    var actionSuccesful: Observable<Bool> { get }
}

protocol WalkthroughSlideableActionsType {
    var continueAction: CocoaAction? { get }
}

protocol WalkthroughSlideableType {
    var inputs: WalkthroughSlideableInputsType { get }
    var outputs: WalkthroughSlideableOutputsType { get }
    var actions: WalkthroughSlideableActionsType { get }
}
