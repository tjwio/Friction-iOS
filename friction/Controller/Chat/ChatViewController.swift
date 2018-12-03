//
//  ChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController, ButtonScrollViewDelegate {
    
    let poll: Poll
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 22.0)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let liveView: LiveView = {
        let liveView = LiveView()
        liveView.translatesAutoresizingMaskIntoConstraints = false
        
        return liveView
    }()
    
    let buttonScrollView: ButtonScrollView = {
        let scrollView = ButtonScrollView()
        scrollView.showPercentage = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let progressView: ProgressLabelView = {
        let view = ProgressLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Grayscale.backgroundLight
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(poll: Poll) {
        self.poll = poll
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackInfoBarButtons()
        
        navigationItem.title = "Today's Clash Chat"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        nameLabel.text = poll.name
        
        let items = poll.items
        buttonScrollView.items = items
        buttonScrollView.selectionDelegate = self
        
        progressView.percents = items.map { return $0.percent }
        
        view.addSubview(nameLabel)
        view.addSubview(liveView)
        view.addSubview(buttonScrollView)
        view.addSubview(progressView)
        view.addSubview(separatorView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-140.0)
        }
        
        liveView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.top).offset(4.0)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(4.0)
        }
        
        buttonScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(16.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
            make.height.equalTo(ButtonScrollView.Constants.Button.height)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(self.buttonScrollView.snp.bottom).offset(16.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2.0)
        }
    }
    
    // MARK: button selection delegate
    
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelect item: (value: String, percent: Double, selected: Bool), at index: Int) {
        
    }
}
