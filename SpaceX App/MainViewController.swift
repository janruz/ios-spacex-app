//
//  MainViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

fileprivate let reuseIdentifier = "rocketLaunchCell"

class MainViewController: UIViewController {
    
    let mockLaunches = [
        RocketLaunch(id: "1", name: "Launch 1", detail: "Pretty good", success: true, date: "2020-02-06"),
        RocketLaunch(id: "2", name: "Launch 2", detail: "Good", success: false, date: "2018-10-03")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    private func layout() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RocketLaunchCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        view.addSubview(collectionView)
        collectionView.fill(view)
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
        return mockLaunches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RocketLaunchCell
        
        cell.rocketLaunch = mockLaunches[indexPath.row]
        
        return cell
    }
}
