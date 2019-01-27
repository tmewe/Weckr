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
import Action
import RxAppState
import UserNotifications

class MainViewController: UIViewController, BindableType, ErrorDisplayable, InfoAlertDisplayable {
    
    typealias ViewModelType = MainViewModelType
    
    var viewModel: ViewModelType!
    var errorView: ErrorViewProtocol = ErrorView.newAutoLayout()

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<AlarmSection>!
    private let disposeBag = DisposeBag()
    
    let tableViewController = UITableViewController();
    
    var tableView: UITableView! { return tableViewController.tableView }
    
    init(viewModel: ViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor

        dataSource = configureDataSource()
        setupTableView()
        bindViewModel()
        errorView.autoSetDimensions(to: view.frame.size)
    }
    
    func bindViewModel() {
        UIApplication.shared.rx.didOpenApp
            .map { _ in Void() }
            .bind(to: viewModel.inputs.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.outputs.sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.dateString
            .asDriver(onErrorJustReturn: "")
            .drive(headerView.dateLabel.rx.text)
            .disposed(by: headerView.disposeBag)
        
        viewModel.outputs.dayString
            .asDriver(onErrorJustReturn: "")
            .drive(headerView.titleLabel.rx.text)
            .disposed(by: headerView.disposeBag)
        
        viewModel.outputs.errorOccurred
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext:  configureErrorView)
            .disposed(by: disposeBag)
        
        viewModel.outputs.showAlert
            .subscribe(onNext: showInfoAlert)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                let insets = Constraints.Main.Tile.self
                
                guard let tileCell = cell as? TileTableViewCell else { return }
                guard let gradient = tileCell.gradient else { return }
                
                let topInset = tileCell.topPadding == .small ? insets.topSmall : insets.top
                let bottomInset = tileCell.bottomPadding == .small ? insets.bottomSmall : insets.bottom

                let frame = CGRect(x: insets.left, y: insets.top,
                                   width: cell.frame.width - insets.left - insets.right,
                                   height: cell.frame.height - topInset - bottomInset)
                
                tileCell.tileView.frame = frame
                tileCell.tileView.setGradientForCell(gradient)
            })
            .disposed(by: disposeBag)
        
        
        //Morning routine selected
        tableView.rx.itemSelected
            .filter { self.tableView.cellForRow(at: $0) is MorningRoutineTableViewCell }
            .map { self.tableView.deselectRow(at: $0, animated: false) }
            .bind(to: viewModel.actions.presentMorningRoutineEdit.inputs)
            .disposed(by: disposeBag)
        
        //Calendar selected
        tableView.rx.itemSelected
            .filter { self.tableView.cellForRow(at: $0) is EventTableViewCell }
            .map { self.tableView.deselectRow(at: $0, animated: false) }
            .bind(to: viewModel.actions.presentCalendarEdit.inputs)
            .disposed(by: disposeBag)
        
        //Route overview selected
        tableView.rx.itemSelected
            .filter { self.tableView.cellForRow(at: $0) is RouteOverviewTableViewCell }
            .map { self.tableView.deselectRow(at: $0, animated: false) }
            .bind(to: viewModel.inputs.toggleRouteVisibility)
            .disposed(by: disposeBag)
        
        //Route edit selected
        tableView.rx.itemSelected
            .filter {
                let cell = self.tableView.cellForRow(at: $0)
                return cell is RoutePedestrianTableViewCell
                    || cell is RouteTransitTableViewCell
                    || cell is RouteCarTableViewCell
            }
            .map { self.tableView.deselectRow(at: $0, animated: false) }
            .bind(to: viewModel.actions.presentTravelEdit.inputs)
            .disposed(by: disposeBag)
        
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        userNotificationCenter.rx.willPresent
            .filter { $0.notification.request.content.categoryIdentifier == "alarm" }
            .do(onNext: { _, _, completion in completion([.alert, .sound]) })
            .map { _ in }
            .bind(to: viewModel.inputs.createNewAlarm)
            .disposed(by: disposeBag)
    }
    
    private func configureErrorView(error: AppError?) {
        
        guard let error = error else {
            self.hideError()
            self.tableView.isScrollEnabled = true
            return
        }
        
        self.tableView.isScrollEnabled = false
        self.showError(error: error)
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
                    cell.configure(with: (title, event))
                    return cell
                case let .routeOverview(_, route, date):
                    let cell: RouteOverviewTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: (route, date))
                    return cell
                case let .routePedestrian(_, maneuver):
                    let cell: RoutePedestrianTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: maneuver)
                    return cell
                case let .routeTransit(_, date, getOn, getOff, transitLines):
                    let cell: RouteTransitTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: date, getOn: getOn, getOff: getOff, lines: transitLines)
                    return cell
                case let .routeCar(_, route):
                    let cell: RouteCarTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
                    cell.configure(with: route)
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
    
    fileprivate func setupTableView() {
        view.addSubview(tableViewController.view)
        tableViewController.view.autoPinEdge(.top, to: .top, of: view, withOffset: UIApplication.shared.statusBarFrame.height)
        tableViewController.view.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 0)
        tableViewController.view.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
        tableViewController.view.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
        
        tableView.registerReusableCell(AlarmTableViewCell.self)
        tableView.registerReusableCell(MorningRoutineTableViewCell.self)
        tableView.registerReusableCell(EventTableViewCell.self)
        tableView.registerReusableCell(RouteOverviewTableViewCell.self)
        tableView.registerReusableCell(RoutePedestrianTableViewCell.self)
        tableView.registerReusableCell(RouteTransitTableViewCell.self)
        tableView.registerReusableCell(RouteCarTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .backgroundColor
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
    }
}
