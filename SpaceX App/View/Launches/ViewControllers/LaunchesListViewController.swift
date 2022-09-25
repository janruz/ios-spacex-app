//
//  LaunchesViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

class LaunchesListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let navigation: LaunchesNavigation
    
    private let viewModel: LaunchesListViewModel
    
    private let tableView = UITableView()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorMessageLabel = UILabel()
    
    private let refreshControl = UIRefreshControl()
    
    private let searchController = UISearchController()
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    
    init(navigation: LaunchesNavigation, viewModel: LaunchesListViewModel) {
        self.navigation = navigation
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        bindData()
        
        viewModel.fetchPastLaunches()
    }
}

//MARK: - ViewModel

extension LaunchesListViewController {
    
    private func bindData() {
        viewModel.rocketLaunches
            .do(onNext: { _ in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            })
            .bind(to: tableView.rx.items(cellIdentifier: RocketLaunchCell.reuseID)) { _, launch, cell in
                (cell as! RocketLaunchCell).viewData = RocketLaunchViewData(from: launch)
            }
            .disposed(by: disposeBag)
        
        viewModel.sortOrder
            .map { order in
                return "Ordered by \(order.title)"
            }
            .bind(to: navigationItem.rightBarButtonItem!.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isError
            .map { isError in
                return !isError
            }
            .bind(to: errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RocketLaunch.self)
            .subscribe(onNext: { [weak self] launch in
                self?.navigation.goToLaunchDetail(of: launch)
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchLaunches(with: query)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Actions

extension LaunchesListViewController {
    
    @objc private func orderButtonTapped() {
       presentSelectOrderActionSheet()
    }
    
    @objc private func refreshContent() {
        viewModel.fetchPastLaunches()
    }
    
    private func presentSelectOrderActionSheet() {
        let actionSheet = UIAlertController(
            title: NSLocalizedString(Strings.RocketLaunches.Sorting.title, comment: "Rocket launches sort order selection action sheet title"),
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(
            title: NSLocalizedString(Strings.RocketLaunches.Sorting.byDateAsc, comment: "Rocket launches date asceding sort order"),
            style: UIAlertAction.Style.default,
            handler: { (action) -> Void in
                self.viewModel.order(by: .dateAsc)
            }
        ))
        
        actionSheet.addAction(UIAlertAction(
            title: NSLocalizedString(Strings.RocketLaunches.Sorting.byDateDesc, comment: "Rocket launches date descending sort order"),
            style: UIAlertAction.Style.default,
            handler: { (action) -> Void in
                self.viewModel.order(by: .dateDesc)
            }
        ))
        
        actionSheet.addAction(UIAlertAction(
            title: NSLocalizedString(Strings.cancel, comment: "Hide the action sheet"),
            style: UIAlertAction.Style.cancel,
            handler: { (action) -> Void in
            }
        ))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - Layout

extension LaunchesListViewController {
    
    private func setup() {
        navigationItem.title = NSLocalizedString(Strings.RocketLaunches.title, comment: "The title for rocket launches list screen")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Order", style: .plain, target: self, action: #selector(orderButtonTapped))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.register(RocketLaunchCell.self, forCellReuseIdentifier: RocketLaunchCell.reuseID)
        tableView.refreshControl = refreshControl
        
        errorMessageLabel.text = "Oops, something went wrong.\nWe could not fetch the launches."
        errorMessageLabel.textColor = .systemRed
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorMessageLabel)
        
        tableView.constrain(
            top: view.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor
        )
        
        activityIndicator.constrain(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
        
        errorMessageLabel.constrain(
            top: view.safeAreaLayoutGuide.topAnchor,
            centerX: view.centerXAnchor
        )
    }
}
