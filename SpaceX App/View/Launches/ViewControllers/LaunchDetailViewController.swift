//
//  LaunchDetailViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewData: LaunchViewData
    
    private let detailLabel = UILabel()
        
    private let successIconLabel = IconLabelView()
    
    private let rocketInfoHeadline = UILabel()
    
    private let rocketNameLabel = UILabel()
    
    private let rocketStatusIconLabel = IconLabelView()
    
    private let launchpadInfoHeadline = UILabel()
    
    private let launchpadNameLabel = UILabel()
    
    private let launchpadStatusIconLabel = IconLabelView()
    
    //MARK: - Lifecycle
    
    init(for launch: Launch) {
        viewData = LaunchViewData(from: launch)
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = viewData.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        bindData()
    }
}

extension LaunchDetailViewController {
    
    private func bindData() {
        detailLabel.text = viewData.details
        
        successIconLabel.configure(
            systemImageName: viewData.successIconName,
            text: viewData.successLabelText,
            tintColor: viewData.successColor
        )
        
        rocketNameLabel.text = viewData.rocketName
        
        rocketStatusIconLabel.configure(
            systemImageName: viewData.rocketStatusIconName,
            text: viewData.rocketStatusLabelText,
            tintColor: viewData.rocketStatusColor
        )
        
        launchpadNameLabel.text = viewData.launchpadName
        
        launchpadStatusIconLabel.configure(
            systemImageName: viewData.launchpadStatusIconName,
            text: viewData.launchpadStatusLabelText,
            tintColor: viewData.launchpadStatusColor
        )
    }
}

extension LaunchDetailViewController {
    
    private func setup() {
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.numberOfLines = 0
        
        rocketInfoHeadline.font = .preferredFont(forTextStyle: .headline)
        rocketInfoHeadline.text = "Rocket"
        
        rocketNameLabel.font = .preferredFont(forTextStyle: .body)
        
        launchpadInfoHeadline.font = .preferredFont(forTextStyle: .headline)
        launchpadInfoHeadline.text = "Launchpad"
        
        launchpadNameLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        
        let rocketInfoStack = makeStack(.vertical, 8, .fill, [
            rocketInfoHeadline, rocketNameLabel, rocketStatusIconLabel
        ])
        
        let launchpadInfoStack = makeStack(.vertical, 8, .fill, [
            launchpadInfoHeadline, launchpadNameLabel, launchpadStatusIconLabel
        ])
        
        let otherInfoStack = makeStack(.horizontal, 0, .fillEqually, .top, [
            rocketInfoStack, launchpadInfoStack
        ])
                
        let stackView = makeStack(.vertical, 16, .fill, .leading, [
            detailLabel, successIconLabel, otherInfoStack
        ])
        
        let scrollView = UIScrollView()
        
        scrollView.addSubview(stackView)
        stackView.constrain(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            width: scrollView.widthAnchor
        )
       
        view.addSubview(scrollView)
        
        scrollView.constrain(
            top: view.topAnchor,
            leading: view.readableContentGuide.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.readableContentGuide.trailingAnchor
        )
    }
}
