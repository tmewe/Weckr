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
        
        editView.tableView.rx.itemSelected
            .map { [weak self] indexPath in
                self?.editView.tableView.deselectRow(at: indexPath, animated: false)
                return try! self?.dataSource?.model(at: indexPath) as! EventEditWrapper
            }
            .bind(to: viewModel.actions.dismiss.inputs)
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxTableViewSectionedReloadDataSource<EventsSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<EventsSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as EventTableViewCell
                cell.configure(with: (item.description, item.event))
                cell.gradient = item.gradient
                return cell
        })
    
        return dataSource
    }
}
