//
//  SceneCoordinatorType.swift
//  RxTimr
//
//  Created by Tim Mewe on 10.11.17.
//  Copyright © 2017 Tim Mewe. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult
    func transition(to scene: Scene, withType type: SceneTransitionType) -> Observable<Void>
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}
