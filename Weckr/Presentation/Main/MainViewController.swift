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
import FoldingCell

class MainViewController: UITableViewController {
    
    private var viewModel: MainViewModelType!
    private var dataSource: RxTableViewSectionedAnimatedDataSource<AlarmSection>!
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
                let insets = Constraints.Main.Tile.self
                let frame = CGRect(x: insets.left, y: insets.top,
                                   width: cell.frame.width-insets.left-insets.right,
                                   height: cell.frame.height-insets.top-insets.bottom)
                
                guard let tileCell = cell as? TileTableViewCell else { return }
                guard let gradient = tileCell.gradient else { return }
                tileCell.tileView.frame = frame
                tileCell.tileView.setGradientForCell(colors: gradient)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .filter { self.tableView.cellForRow(at: $0) is RouteTableViewCell }
            .map { _ in Void() }
            .bind(to: viewModel.inputs.toggleRouteVisibility)
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxTableViewSectionedAnimatedDataSource<AlarmSection> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AlarmSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case let .alarm(_, date):
                    let cell: AlarmTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: date)
                    return cell
                case let .morningRoutine(_, time):
                    let cell: MorningRoutineTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: time)
                    return cell
                case let .event(_, title, event):
                    let cell: EventTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: title, event: event)
                    return cell
                case let .routeOverview(_, route):
                    let cell: RouteTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: route)
                    return cell
                default:
                    let cell: RouteTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    return cell
                }
        })
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .fade)
        
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
        tableView.registerReusableCell(RouteTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .backgroundColor
        tableView.delegate = self
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
    }
}
