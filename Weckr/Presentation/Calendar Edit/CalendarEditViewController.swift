//
//  CalendarEditViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class CalendarEditViewController: UIViewController, BindableType {
    
    typealias ViewModelType = CalendarEditViewModelType
    
    private let editView = CalendarEditView()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<EventsSection>!
    var viewModel: ViewModelType!
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = configureDataSource()
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        view.isOpaque = false
        view.backgroundColor = .clear
        view.addSubview(editView)
        editView.autoPinEdgesToSuperviewEdges()
    }
    
    func bindViewModel() {
        viewModel.outputs.events
            .asDriver(onErrorJustReturn: [])
            .drive(editView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxTableViewSectionedReloadDataSource<EventsSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<EventsSection>(
            configureCell: { dataSource, tableView, indexPath, event in
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as EventTableViewCell
                cell.configure(with: ("first event", event))
                return cell
        })
    
        return dataSource
    }
}
