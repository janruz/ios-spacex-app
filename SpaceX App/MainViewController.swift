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
            launchesCollectionView.reloadData()
        }
    }
    
    private lazy var launchesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RocketLaunchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
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
        view.addSubview(launchesCollectionView)
        launchesCollectionView.fill(view)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width - 2 * 12
        
        if width > 350 {
            width = 350
        }
        
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rocketLaunches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RocketLaunchCell
        
        cell.rocketLaunch = rocketLaunches[indexPath.row]
        
        return cell
    }
}
