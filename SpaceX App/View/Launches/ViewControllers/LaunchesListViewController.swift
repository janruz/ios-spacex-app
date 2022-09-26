//
//  LaunchesListViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit
import Combine

class LaunchesListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let navigation: LaunchesNavigation
    
    private let viewModel: LaunchesListViewModel
    
    private let tableView = UITableView()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorMessageLabel = UILabel()
    
    private let refreshControl = UIRefreshControl()
    
    private let searchController = UISearchController()
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        viewModel.$launches
            .receive(on: RunLoop.main)
            .sink { launches in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$sortOrder
            .receive(on: RunLoop.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
            .store(in: &subscriptions)
        
        viewModel.$isRefreshing
            .receive(on: RunLoop.main)
            .sink { isRefreshing in
                isRefreshing ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
            }
            .store(in: &subscriptions)
        
        viewModel.$isError
            .map { isError in
                return !isError
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: errorMessageLabel)
            .store(in: &subscriptions)
    }
}

//MARK: - TableView

extension LaunchesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.reuseID, for: indexPath) as! LaunchCell
        cell.configure(with: LaunchViewData(from: viewModel.launches[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ordered by \(viewModel.sortOrder.title)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigation.goToLaunchDetail(of: viewModel.launches[indexPath.row])
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
        
        let searchTextPublisher = NotificationCenter.default.publisher(
            for: UISearchTextField.textDidChangeNotification,
            object: searchController.searchBar.searchTextField
        )

        searchTextPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { notification in
                (notification.object as? UISearchTextField)?.text ?? ""
            }
            .sink { query in
                self.viewModel.searchLaunches(with: query)
            }
            .store(in: &subscriptions)
        
        let cancelSearchPublisher = NotificationCenter.default.publisher(
            for: UISearchTextField.textDidEndEditingNotification,
            object: searchController.searchBar.searchTextField
        )
        
        cancelSearchPublisher
            .sink { _ in
                self.viewModel.searchLaunches(with: "")
            }
            .store(in: &subscriptions)
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
