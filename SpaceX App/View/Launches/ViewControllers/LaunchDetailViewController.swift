//
//  LaunchDetailViewController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rocketLaunch: RocketLaunch
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let upcomingIconLabel = IconLabelView()
    
    private let successIconLabel = IconLabelView()
    
    //MARK: - Lifecycle
    
    init(for rocketLaunch: RocketLaunch) {
        self.rocketLaunch = rocketLaunch
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = self.rocketLaunch.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
        detailLabel.text = self.rocketLaunch.details
        upcomingIconLabel.setUp(
            systemImageName: "clock.fill",
            text: NSLocalizedString(Strings.RocketLaunches.upcoming, comment: "Upcoming rocket launch label"),
            tintColor: .systemOrange
        )
        successIconLabel.setUp(
            systemImageName: "checkmark.seal.fill",
            text: NSLocalizedString(Strings.RocketLaunches.successful, comment: "Successful rocket launch label"),
            tintColor: .systemGreen
        )
    }
    
    //MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(detailLabel)
        
        let iconLabelsStack = UIStackView()
        iconLabelsStack.axis = .horizontal
        iconLabelsStack.spacing = 16
        iconLabelsStack.distribution = .fillProportionally
        
        iconLabelsStack.addArrangedSubview(upcomingIconLabel)
        iconLabelsStack.addArrangedSubview(successIconLabel)
        
        stackView.addArrangedSubview(iconLabelsStack)
        
        let scrollView = UIScrollView()
        
        scrollView.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.constrain(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor
        )
       
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: scrollView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1)
        ])
    }
}
