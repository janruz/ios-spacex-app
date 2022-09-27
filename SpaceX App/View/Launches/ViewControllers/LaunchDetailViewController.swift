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
    
    private let dateLabel = UILabel()
        
    private let successIconLabel = IconLabelView()
    
    private let moreDetailsHeadline = UILabel()
    
    private let rocketNameLabel = UILabel()
    
    private let launchpadNameLabel = UILabel()
    
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
        dateLabel.text = viewData.dateText
        
        successIconLabel.configure(
            systemImageName: viewData.successIconName,
            text: viewData.successLabelText,
            tintColor: viewData.successColor
        )
        
        rocketNameLabel.attributedText = viewData.rocketText
        
        launchpadNameLabel.attributedText = viewData.launchpadText
    }
}

extension LaunchDetailViewController {
    
    private func setup() {
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.numberOfLines = 0
        
        dateLabel.font = .preferredFont(forTextStyle: .body)
        dateLabel.textColor = .systemGray
        
        moreDetailsHeadline.font = .preferredFont(forTextStyle: .headline)
        moreDetailsHeadline.text = NSLocalizedString(Strings.moreDetails, comment: "More launch details label")
        
        rocketNameLabel.font = .preferredFont(forTextStyle: .body)
        
        launchpadNameLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
    
        let separator = UIView()
        separator.backgroundColor = .separator
        
        let stackView = makeStack(.vertical, 16, .fill, .leading, [
            detailLabel,
            dateLabel,
            successIconLabel,
            separator,
            moreDetailsHeadline,
            rocketNameLabel,
            launchpadNameLabel
        ])
        
        separator.constrain(width: stackView.widthAnchor, heightConstant: 1)
        
        let scrollView = UIScrollView()
        
        scrollView.addSubview(stackView)
        stackView.constrain(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
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
