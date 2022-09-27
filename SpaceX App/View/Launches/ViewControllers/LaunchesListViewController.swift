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
            .sink { _ in
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
            .receive(on: RunLoop.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
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
        navigationItem.title = NSLocalizedString(Strings.Launches.title, comment: "The title for rocket launches list screen")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString(Strings.order, comment: "Change launches order"),
            style: .plain,
            target: self,
            action: #selector(orderButtonTapped)
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.register(LaunchCell.self, forCellReuseIdentifier: LaunchCell.reuseID)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        searchController.searchBar.delegate = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
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
    }
}

//MARK: - Search

extension LaunchesListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchLaunches(with: "")
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        if viewModel.isError {
            label.text = NSLocalizedString(Strings.Errors.defaultErrorMessage, comment: "Error message")
            label.textColor = .systemRed
            label.textAlignment = .center
        } else if !viewModel.isLoading && !viewModel.isRefreshing {
            
            if viewModel.launches.isEmpty {
                
                if viewModel.allLaunches.isEmpty {
                    label.text = NSLocalizedString(
                        Strings.Launches.noLaunches,
                        comment: "No launches to be displayed"
                    )
                } else {
                    label.text = NSLocalizedString(
                        Strings.Launches.noLaunchesMatchingSearchQuery,
                        comment: "No launches match the given search query"
                    )
                }
                
            } else {
                label.text = "Ordered by \(viewModel.sortOrder.title)"
            }
            
            label.textColor = .systemGray
        } else {
            label.text = ""
        }
        
        let parent = UIView()
        parent.backgroundColor = .systemBackground
        
        parent.addSubview(label)
        label.constrain(
            top: parent.topAnchor,
            leading: parent.leadingAnchor,
            bottom: parent.bottomAnchor,
            trailing: parent.trailingAnchor,
            constantTop: 8,
            constantLeading: 16,
            constantBottom: -8,
            constantTrailing: -16
        )

        return parent
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigation.goToLaunchDetail(of: viewModel.launches[indexPath.row])
    }
}
