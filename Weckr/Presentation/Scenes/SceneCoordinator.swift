//
//  SceneCoordinator.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController!
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    func actualViewController(for viewController: UIViewController) -> UIViewController {
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController.topViewController!
        }
        return viewController
    }
    
    @discardableResult
    func transition(to scene: Scene, withType type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()

        switch type {
        case .root:
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            subject.onCompleted()
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("No navigation controller")
            }
            
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(
                    #selector(
                        UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            navigationController.pushViewController(viewController, animated: true)
            
        case .modal:
            viewController.modalPresentationStyle = .overCurrentContext
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
        }
        currentViewController = actualViewController(for: viewController)
        
        return subject.asObservable().take(1)

    }
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            currentViewController = actualViewController(for: navigationController.viewControllers.last!)
        } else if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = self.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else {
            fatalError("Cant navigate back")
        }
        
        return subject.asObservable().take(1)
    }
}
