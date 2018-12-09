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
    private var dataSource: RxTableViewSectionedAnimatedDataSource<AlarmSectionModel>!
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
    }
    
    private func configureDataSource() -> RxTableViewSectionedAnimatedDataSource<AlarmSectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AlarmSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case let .alarmSectionItem(_, date):
                    let cell: AlarmTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: date)
                    return cell
                default:
                    let cell: AlarmTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
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
