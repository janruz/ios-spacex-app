//
//  LaunchDetailViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewData: RocketLaunchViewData
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let upcomingIconLabel = IconLabelView()
    
    private let successIconLabel = IconLabelView()
    
    private let rocketInfoHeadline: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Rocket"
        
        return label
    }()
    
    private let rocketNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let rocketStatusIconLabel = IconLabelView()
    
    private let launchpadInfoHeadline: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Launchpad"
        
        return label
    }()
    
    private let launchpadNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let launchpadStatusIconLabel = IconLabelView()
    
    //MARK: - Lifecycle
    
    init(for rocketLaunch: RocketLaunch) {
        viewData = RocketLaunchViewData(from: rocketLaunch)
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = viewData.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
        detailLabel.text = viewData.details
        
        upcomingIconLabel.setUp(
            systemImageName: viewData.upcomingIconName,
            text: viewData.upcomingLabelText,
            tintColor: viewData.upcomingColor
        )
        successIconLabel.setUp(
            systemImageName: viewData.successIconName,
            text: viewData.successLabelText,
            tintColor: viewData.successColor
        )
        
        rocketNameLabel.text = viewData.rocketName
        
        rocketStatusIconLabel.setUp(
            systemImageName: viewData.rocketStatusIconName,
            text: viewData.rocketStatusLabelText,
            tintColor: viewData.rocketStatusColor
        )
        
        launchpadNameLabel.text = viewData.launchpadName
        
        launchpadStatusIconLabel.setUp(
            systemImageName: viewData.launchpadStatusIconName,
            text: viewData.launchpadStatusLabelText,
            tintColor: viewData.launchpadStatusColor
        )
    }
    
    //MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(detailLabel)
        
        let iconLabelsStack = UIStackView()
        iconLabelsStack.axis = .horizontal
        iconLabelsStack.spacing = 16
        
        iconLabelsStack.addArrangedSubview(upcomingIconLabel)
        iconLabelsStack.addArrangedSubview(successIconLabel)
        
        stackView.addArrangedSubview(iconLabelsStack)
        
        let otherInfoStack = UIStackView()
        otherInfoStack.axis = .horizontal
        otherInfoStack.distribution = .fillEqually
        otherInfoStack.alignment = .top
        
        let rocketInfoStack = UIStackView()
        rocketInfoStack.axis = .vertical
        rocketInfoStack.spacing = 8
        
        rocketInfoStack.addArrangedSubview(rocketInfoHeadline)
        rocketInfoStack.addArrangedSubview(rocketNameLabel)
        rocketInfoStack.addArrangedSubview(rocketStatusIconLabel)
        
        let launchpadInfoStack = UIStackView()
        launchpadInfoStack.axis = .vertical
        launchpadInfoStack.spacing = 8
        
        launchpadInfoStack.addArrangedSubview(launchpadInfoHeadline)
        launchpadInfoStack.addArrangedSubview(launchpadNameLabel)
        launchpadInfoStack.addArrangedSubview(launchpadStatusIconLabel)
        
        otherInfoStack.addArrangedSubview(rocketInfoStack)
        otherInfoStack.addArrangedSubview(launchpadInfoStack)
        
        stackView.addArrangedSubview(otherInfoStack)
        
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
