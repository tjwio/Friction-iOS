//
//  ChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController, ButtonScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let cellIdentifier = "ChatMessageTableViewCellIdentifier"
    }
    
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
    
    let textField: ChatTextField = {
        let textField = ChatTextField()
        textField.borderStyle = .none
        textField.font = .avenirRegular(size: 16.0)
        textField.layer.borderColor = UIColor.Grayscale.light.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 22.0
        textField.placeholder = "Type a message..."
        textField.textColor = UIColor.Grayscale.dark
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        view.addSubview(tableView)
        view.addSubview(textField)
        
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.separatorView.snp.bottom)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8.0)
            make.height.equalTo(44.0)
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? FullMessageTableViewCell ?? FullMessageTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        cell.messageView.nameLabel.text = "Poggers247"
        cell.messageView.timeLabel.text = "2:47pm"
        cell.messageView.messageLabel.text = "YO KENDRICK IS THE GOAT"
        cell.clapView.claps.value = 229
        
        cell.messageView.layer.borderWidth = 1.0
        cell.messageView.layer.borderColor = UIColor.pollColor(index: 0).cgColor
        
        return cell
    }
    
    // MARK: button selection delegate
    
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelect item: (value: String, percent: Double, selected: Bool), at index: Int) {
        let option = poll.options[index]
        
        poll.vote(option: option, success: { _ in
            let items = self.poll.items
            self.buttonScrollView.items = items
            self.progressView.percents = items.map { return $0.percent }
        }) { _ in
            self.buttonScrollView.items = self.poll.items
        }
    }
}
