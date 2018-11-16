//
//  WalkthroughViewModel.swift
//  Weckr
//
//  Created by Tim Mewe on 03.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift

protocol WalkthroughViewModelInputsType {
    var nextPage: PublishSubject<Void> { get }
    var previousPage: PublishSubject<Void> { get }
    var scrollAmount: PublishSubject<CGFloat> { get }
}

protocol WalkthroughViewModelOutputsType {
    var pageNumber : Observable<Int> { get }
    var slides : Observable<[WalkthroughSlideWrapper]> { get }
    var buttonColor: Observable<UIColor> { get }
}

protocol WalkthroughViewModelType {
    var inputs : WalkthroughViewModelInputsType { get }
    var outputs : WalkthroughViewModelOutputsType { get }
}

class WalkthroughViewModel: WalkthroughViewModelType {
    
    var inputs: WalkthroughViewModelInputsType { return self }
    var outputs: WalkthroughViewModelOutputsType { return self }
    
    //Setup
    private var internalPageNumber = BehaviorSubject(value: 0)
    private var internalButtonColor = BehaviorSubject(value: UIColor.walkthroughPurpleAccent)
    
    private let disposeBag = DisposeBag()
    
    //Inputs
    var nextPage: PublishSubject<Void>
    var previousPage: PublishSubject<Void>
    var scrollAmount: PublishSubject<CGFloat>
    
    //Outputs
    var pageNumber: Observable<Int>
    var slides: Observable<[WalkthroughSlideWrapper]>
    var buttonColor: Observable<UIColor>
    
    init() {
        
        //Setup
        let landingView = LandingPageViewController.init(nibName: nil, bundle: nil)
        let calendarView = CalendarViewController.init(nibName: nil, bundle: nil)
        let locationView = LocationViewController.init(nibName: nil, bundle: nil)
        
        let landing = WalkthroughSlideWrapper(
            view: landingView.view,
            buttonColor: UIColor.walkthroughPurpleAccent,
            buttonText: "walkthrough.landing.buttonTitle".localized())
        
        let calendar = WalkthroughSlideWrapper(
            view: calendarView.view,
            buttonColor: UIColor.walkthroughGreenAccent,
            buttonText: "walkthrough.calendar.buttonTitle".localized())
        
        let location = WalkthroughSlideWrapper(
            view: locationView.view,
            buttonColor: UIColor.walkthroughOrangeAccent,
            buttonText: "walkthrough.location.buttonTitle".localized())
        
        //Inputs
        nextPage = PublishSubject()
        previousPage = PublishSubject()
        scrollAmount = PublishSubject()
        
        //Outputs
        pageNumber = internalPageNumber.asObservable()
        slides = Observable.of([landing, calendar, location])
        buttonColor = internalButtonColor.asObservable()
        
        nextPage
            .withLatestFrom(internalPageNumber)
            .map { $0 + 1 }
            .withLatestFrom(slides) {($0, $1)}
            .filter { $0.0 < $0.1.count }
            .map { $0.0 }
            .bind(to: internalPageNumber)
            .disposed(by: disposeBag)
        
        previousPage
            .withLatestFrom(internalPageNumber)
            .map { $0 - 1 }
            .filter { $0 >= 0 }
            .bind(to: internalPageNumber)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(scrollAmount, slides)
            .map{ (arg) -> UIColor in let (amount, s) = arg
                return s[Int(floor(amount))].buttonColor}
            .bind(to: internalButtonColor)
            .disposed(by: disposeBag)
        
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}


