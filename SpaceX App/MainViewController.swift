//
//  MainViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit
import Alamofire

fileprivate let reuseIdentifier = "rocketLaunchCell"

class MainViewController: UIViewController {
    
    private var rocketLaunches = [RocketLaunch]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.register(RocketLaunchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        Task {
            let result = await RocketLaunchesRepository.shared.getLaunches()
            
            switch result {
            case .success(let launches):
                self.rocketLaunches = launches
            case .failure(_):
                break
            }
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.constrain(
            top: view.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor
        )
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rocketLaunches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RocketLaunchCell
        cell.rocketLaunch = rocketLaunches[indexPath.row]
        return cell
    }
}
