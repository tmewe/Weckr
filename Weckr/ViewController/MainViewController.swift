//
//  MainViewController.swift
//  Weckr
//
//  Created by Tim Lehmann on 01.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UITableViewController {
    
    private var viewModel: MainViewModelType!
    private var dataSource: RxTableViewSectionedReloadDataSource<AlarmSection>!
    private let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        dataSource = configureDataSource()
        setupViews()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.outputs.sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.dateString
            .asDriver(onErrorJustReturn: "")
            .drive(headerView.dateLabel.rx.text)
            .disposed(by: headerView.disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                let frame = CGRect(x: 0, y: 0, width: cell.frame.width-26, height: cell.frame.height-10)
                guard let tileCell = cell as? TileTableViewCell else { return }
                guard let gradient = tileCell.gradient else { return }
                tileCell.tileView.frame = frame
                tileCell.tileView.setGradientForCell(colors: gradient)
            })
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .subscribe(onNext: { indexPath in
//                guard let cell = self.tableView.cellForRow(at: indexPath) as? TileTableViewCell else {
//                    return
//                }
//                guard let editCell = cell as? EditableCell else {
//                    return
//                }
//                editCell.showEditIcon()
//            })
//            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxTableViewSectionedReloadDataSource<AlarmSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<AlarmSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case let .alarmItem(date):
                    let cell: AlarmTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: date)
                    return cell
                case let .morningRoutineItem(time):
                    let cell: MorningRoutineTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: time)
                    return cell
                case let .eventItem(title, event):
                    let cell: EventTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: title, event: event)
                    return cell
                }
        })
        return dataSource
    }
    
    var headerView: AlarmTableHeaderView = {
        let view = AlarmTableHeaderView.newAutoLayout()
        return view
    }()
}

// MARK: UI Elements
extension MainViewController {
    fileprivate func setupViews() {
        tableView.registerReusableCell(AlarmTableViewCell.self)
        tableView.registerReusableCell(MorningRoutineTableViewCell.self)
        tableView.registerReusableCell(EventTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .backgroundColor
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
    }
}
