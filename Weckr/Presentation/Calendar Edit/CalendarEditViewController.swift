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
    private var dataSource: RxTableViewSectionedReloadDataSource<CalendarEditSection>!
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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.backGroundColorTransparent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.backgroundColor
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
            .drive(self.editView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        editView.tableView.rx.itemSelected
            .filter { self.editView.tableView.cellForRow(at: $0) is EventTableViewCell }
            .map { [weak self] (indexPath) -> EventEditWrapper? in
                self?.editView.tableView.deselectRow(at: indexPath, animated: false)
                let item = try! self?.dataSource?.model(at: indexPath) as! CalendarEditSectionItem
                switch item {
                case .title(_):
                    return nil
                case let .calendarItem(eventWrapper):
                    return eventWrapper
                }
            }
            .filterNil()
            .take(1)
            .bind(to: viewModel.actions.dismiss.inputs)
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxTableViewSectionedReloadDataSource<CalendarEditSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<CalendarEditSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                
                switch dataSource[indexPath] {
                case let .title(text, coloredPart):
                    let cell: CalendarEditTitleTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: text, coloredPart: coloredPart)
                    return cell
                case let .calendarItem(eventWrapper):
                    let cell: EventTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: (eventWrapper.description, eventWrapper.event))
                    cell.gradient = eventWrapper.gradient
                    return cell
                }
                
             
        })
    
        return dataSource
    }
}
