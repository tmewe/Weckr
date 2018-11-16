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
    var slides: Observable<[WalkthroughPageViewController]>
    var buttonColor: Observable<UIColor>
    
    init() {
        
        //Setup
        let landingViewModel = LandingPageViewModel()
        
        let landingPage = WalkthroughPageViewController(viewModel: landingViewModel)
        
        
        
        //Inputs
        nextPage = PublishSubject()
        previousPage = PublishSubject()
        scrollAmount = PublishSubject()
        
        //Outputs
        pageNumber = internalPageNumber.asObservable()
        slides = Observable.of([landingPage])
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
            .map { $0.1[Int(floor($0.0))] }
            .map { $0.viewModel.outputs.accentColor }
            
            //TODO : Hier liegen Leichen beraben
            .asDriver(onErrorJustReturn: <#T##Observable<CGColor>#>))
            .drive
            
        
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}


