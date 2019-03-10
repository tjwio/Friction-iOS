//
//  ChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BaseChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let cellIdentifier = "ChatMessageTableViewCellIdentifier"
    }
    
    let poll: Poll
    var option: Poll.Option
    
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
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let progressView: ProgressView = {
        let view = ProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(poll: Poll, option: Poll.Option) {
        self.poll = poll
        self.option = option
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackInfoBarButtons()
        
        navigationItem.title = GlobalStrings.todaysClashChat.localized
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = poll.name
        
        let items = poll.items
        buttonScrollView.items = items
        
        progressView.percents = items.map { return $0.percent }
        progressView.layer.applySketchShadow(color: UIColor.Grayscale.light, alpha: 0.50, x: 3.0, y: 4.0, blur: 8.0, spread: 0.0)
        
        view.addSubview(nameLabel)
        view.addSubview(liveView)
        view.addSubview(buttonScrollView)
        view.addSubview(tableView)
        view.addSubview(progressView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        reloadMessages(nil)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-100.0)
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(4.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.tableView)
        }
    }
    
    // MARK: reload
    
    private func reloadMessages(_ sender: UIRefreshControl?) {
        poll.getMessages(success: { messages in
            self.activityIndicator.stopAnimating()
            sender?.endRefreshing()
            self.tableView.reloadData()
            self.messagesDidReload(messages)
        }) { error in
            print("failed to get messages with error: \(error)")
            self.activityIndicator.stopAnimating()
            sender?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activityIndicator.isAnimating ? 0 : poll.messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView: tableView, message: poll.messages[indexPath.section])
    }
    
    func getCell(tableView: UITableView, message: Message) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? FullMessageTableViewCell ?? FullMessageTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        var color = UIColor.pollColor(index: 0)
        if let option = message.option, let index = poll.options.firstIndex(of: option) {
            color = .pollColor(index: index)
        }
        
        cell.nameLabel.text = message.name
        cell.timeLabel.text = DateFormatter.amPm.string(from: message.date)
        cell.messageView.messageLabel.text = message.message
        cell.clapView.claps.value = message.claps
        cell.dislikeView.claps.value = message.dislikes
        
        cell.clapView.isUserInteractionEnabled = false
        cell.dislikeView.isUserInteractionEnabled = false
        
        if let imageUrl = message.imageUrl {
            cell.avatarView.imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        } else {
            cell.avatarView.imageView.image = .blankAvatarBlack
        }
        
        cell.messageView.backgroundColor = color
        
        cell.clapView.layer.borderColor = color.cgColor
        cell.clapView.layer.borderWidth = 1.0
        cell.clapView.layer.applySketchShadow(color: color, alpha: 1.0, x: 0.5, y: 1.0, blur: 3.0, spread: 0.0)
        
        cell.dislikeView.layer.borderColor = color.cgColor
        cell.dislikeView.layer.borderWidth = 1.0
        cell.dislikeView.layer.applySketchShadow(color: color, alpha: 1.0, x: 0.5, y: 1.0, blur: 3.0, spread: 0.0)
        
        return cell
    }
    
    // MARK: helper
    
    func scrollToBottom() {
        guard !poll.messages.isEmpty else { return }
        let indexPath = IndexPath(row: 0, section: poll.messages.count-1)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func messagesDidReload(_ messages: [Message]) {
        
    }
}
