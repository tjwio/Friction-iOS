//
//  ChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BaseChatViewController: UIViewController, ButtonScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let cellIdentifier = "ChatMessageTableViewCellIdentifier"
    }
    
    let poll: Poll
    var option: Poll.Option
    
    var messages = [Message]()
    
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
        buttonScrollView.selectionDelegate = self
        
        progressView.percents = items.map { return $0.percent }
        
        view.addSubview(nameLabel)
        view.addSubview(liveView)
        view.addSubview(buttonScrollView)
        view.addSubview(progressView)
        view.addSubview(separatorView)
        view.addSubview(tableView)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-52.0)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.tableView)
        }
    }
    
    // MARK: reload
    
    private func reloadMessages(_ sender: UIRefreshControl?) {
        NetworkHandler.shared.getMessages(pollId: poll.id, success: { messages in
            self.messages = messages.sorted { return $0.date < $1.date }
            self.activityIndicator.stopAnimating()
            sender?.endRefreshing()
            self.tableView.reloadData()
            self.scrollToBottom()
        }) { error in
            print("failed to get messages with error: \(error)")
            self.activityIndicator.stopAnimating()
            sender?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activityIndicator.isAnimating ? 0 : messages.count
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
        
        let message = messages[indexPath.section]
        
        cell.messageView.nameLabel.text = message.name
        cell.messageView.timeLabel.text = DateFormatter.amPm.string(from: message.date)
        cell.messageView.messageLabel.text = message.message
        cell.clapView.claps.value = message.claps
        if let imageUrl = message.imageUrl {
            cell.avatarView.imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        } else {
            cell.avatarView.imageView.image = .blankAvatarBlack
        }
        
        cell.messageView.layer.borderWidth = 1.0
        cell.messageView.layer.borderColor = UIColor.pollColor(index: message.poll.options.firstIndex(of: message.option) ?? 0).cgColor
        
        cell.clapCallback = { [weak message] claps in
            message?.addClaps(claps, success: nil, failure: nil)
        }
        
        return cell
    }
    
    // MARK: button selection delegate
    
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelect item: (value: String, percent: Double, selected: Bool), at index: Int) {
        let option = poll.options[index]
        
        poll.vote(option: option, success: { _ in
            self.option = option
            let items = self.poll.items
            self.buttonScrollView.items = items
            self.progressView.percents = items.map { return $0.percent }
        }) { _ in
            self.buttonScrollView.items = self.poll.items
        }
    }
    
    // MARK: helper
    
    func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: 0, section: messages.count-1)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
