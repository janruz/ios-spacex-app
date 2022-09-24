//
//  LaunchesViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let reuseIdentifier = "rocketLaunchCell"

class LaunchesListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let navigation: LaunchesNavigation
    
    private let viewModel: LaunchesListViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.register(RocketLaunchCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        return tableView
    }()
    
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
        
        navigationItem.title = NSLocalizedString(Strings.RocketLaunches.title, comment: "The title for rocket launches list screen")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Order", style: .plain, target: self, action: #selector(orderButtonTapped))
        
        configureUI()
        configureViewModel()
    }
    
    //MARK: - Layout
    
    private func configureUI() {
        view.addSubview(tableView)
        
        tableView.constrain(
            top: view.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor
        )
        
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                self.viewModel.searchLaunches(with: query)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureViewModel() {
        viewModel.fetchPastLaunches()
        
        viewModel.rocketLaunches.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) { _, launch, cell in
            (cell as! RocketLaunchCell).viewData = RocketLaunchViewData(from: launch)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RocketLaunch.self)
            .subscribe(onNext: { [weak self] launch in
                self?.navigation.goToLaunchDetail(of: launch)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Selectors
    
    @objc private func orderButtonTapped() {
       showOrderSelectionActionSheet()
    }
    
    //MARK: - Helpers
    
    private func showOrderSelectionActionSheet() {
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