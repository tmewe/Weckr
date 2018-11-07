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
    
}

protocol WalkthroughViewModelOutputsType {
    var pageNumber : Observable<Int> { get }
    var slides : Observable<[UIView]> { get }
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
    private let disposeBag = DisposeBag()
    
    //Inputs
    var nextPage: PublishSubject<Void>
    var previousPage: PublishSubject<Void>
    
    //Outputs
    var pageNumber: Observable<Int>
    var slides: Observable<[UIView]>
    
    init() {
        
        //Setup
        let landing = LandingPageViewController.init(nibName: nil, bundle: nil)
        let calendar = CalendarViewController.init(nibName: nil, bundle: nil)
        
        //Inputs
        nextPage = PublishSubject()
        previousPage = PublishSubject()
        
        //Outputs
        pageNumber = internalPageNumber.asObservable()
        slides = Observable.of([landing.view, calendar.view])
        
        Observable.combineLatest(nextPage, slides) {($0, $1)}
            .map { $0.1.count }
            .subscribe(onNext: {[weak self] maxPages in
                guard let page = try! self?.internalPageNumber.value() else {
                    return
                }
                if page < maxPages {
                    self?.internalPageNumber.onNext(page + 1)
                }
                
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(previousPage, slides) {($0, $1)}
            .map { $0.1.count }
            .subscribe(onNext: {[weak self] maxPages in
                guard let page = try! self?.internalPageNumber.value() else {
                    return
                }
                if page < maxPages {
                    self?.internalPageNumber.onNext(page - 1)
                }
                
            })
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel: WalkthroughViewModelInputsType, WalkthroughViewModelOutputsType {}
