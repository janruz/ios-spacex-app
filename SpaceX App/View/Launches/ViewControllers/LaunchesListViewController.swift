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
        configureUI()
        configureViewModel()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        
        tableView.constrain(
            top: view.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor
        )
    }
    
    private func configureViewModel() {
        viewModel.fetchLaunches()
        
        viewModel.rocketLaunches.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) { _, launch, cell in
            (cell as! RocketLaunchCell).viewData = RocketLaunchViewData(from: launch)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RocketLaunch.self)
           .subscribe(onNext: { [weak self] launch in
               self?.navigation.goToLaunchDetail(of: launch)
        }).disposed(by: disposeBag)
    }
}
