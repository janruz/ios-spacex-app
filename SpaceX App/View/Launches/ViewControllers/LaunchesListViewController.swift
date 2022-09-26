//
//  LaunchesListViewController.swift
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
    
    private var launches = [Launch]()
    
    private var sortOrder: LaunchSortOrder?
    
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
        
        viewModel.fetchLaunches()
    }
}

//MARK: - ViewModel

extension LaunchesListViewController {
    
    private func bindData() {
        
        viewModel.launches
            .subscribe(onNext: { launches in
                self.launches = launches
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.sortOrder
            .bind(to: self.rx.sortOrder)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.isError
            .map { isError in
                return !isError
            }
            .bind(to: errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension LaunchesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.reuseID, for: indexPath) as! LaunchCell
        cell.configure(with: LaunchViewData(from: launches[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let safeSortOrder = sortOrder else {
            return nil
        }
        
        return "Ordered by \(safeSortOrder.title)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigation.goToLaunchDetail(of: launches[indexPath.row])
    }
}

//MARK: - Actions

extension LaunchesListViewController {
    
    @objc private func orderButtonTapped() {
       presentSelectOrderActionSheet()
    }
    
    @objc private func refreshContent() {
        viewModel.refreshLaunches()
    }
    
    private func presentSelectOrderActionSheet() {
        let actionSheet = makeSelectOrderActionSheet(onSelect: { sortOrder in
            self.viewModel.order(by: sortOrder)
        })
        
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
        tableView.register(LaunchCell.self, forCellReuseIdentifier: LaunchCell.reuseID)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        
        errorMessageLabel.text = "Oops, something went wrong.\nWe could not fetch the launches."
        errorMessageLabel.textColor = .systemRed
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchLaunches(with: query)
            })
            .disposed(by: disposeBag)
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
