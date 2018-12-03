//
//  ChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit
import SwiftPhoenixClient

class ChatViewController: UIViewController, ButtonScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private struct Constants {
        static let cellIdentifier = "ChatMessageTableViewCellIdentifier"
        
        struct Channel {
            static let lobby = "room:lobby"
            static let shout = "shout"
        }
    }
    
    let poll: Poll
    var option: Poll.Option {
        didSet {
            updateSendColor()
        }
    }
    
    let socket = Socket(url: AppManager.shared.environment.streamUrl, params: ["token" : AuthenticationManager.shared.authToken ?? ""])
    var lobby: Channel!
    
    private var messages = [Message]()
    
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
    
    let chatBox: ChatBoxView = {
        let view = ChatBoxView()
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
    
    lazy var defaultTextFieldConstraints: (SnapKit.ConstraintMaker) -> Void = { make in
        make.leading.equalToSuperview().offset(16.0)
        make.trailing.equalToSuperview().offset(-16.0)
        make.height.equalTo(52.0)
    }
    
    init(poll: Poll, option: Poll.Option) {
        self.poll = poll
        self.option = option
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackInfoBarButtons()
        
        navigationItem.title = "Today's Clash Chat"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        chatBox.textField.delegate = self
        chatBox.sendButton.addTarget(self, action: #selector(self.sendMessage(_:)), for: .touchUpInside)
        
        nameLabel.text = poll.name
        
        let items = poll.items
        buttonScrollView.items = items
        buttonScrollView.selectionDelegate = self
        
        progressView.percents = items.map { return $0.percent }
        
        updateSendColor()
        
        view.addSubview(nameLabel)
        view.addSubview(liveView)
        view.addSubview(buttonScrollView)
        view.addSubview(progressView)
        view.addSubview(separatorView)
        view.addSubview(tableView)
        view.addSubview(chatBox)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        reloadMessages(nil)
        addSocketEvents()
        
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-52.0)
        }
        
        chatBox.snp.makeConstraints { make in
            self.defaultTextFieldConstraints(make)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-4.0)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.tableView)
        }
    }
    
    // MARK: socket/channel
    
    private func addSocketEvents() {
        socket.onOpen { print("socket connected") }
        socket.onClose { print("socket disconnected") }
        socket.onError { error in print("socket error: \(error)") }
        socket.onMessage { message in
            print("socket message: \(message.event) with error: \(message.payload)")
        }
        
        lobby = socket.channel(Constants.Channel.lobby)
        lobby.on(Constants.Channel.shout) { [weak self] message in
            self?.chatBox.textField.text = ""
            self?.chatBox.sendButton.isLoading = false
            guard let message = message.payload.decodeJson(Message.self), let strongSelf = self else { return }
            strongSelf.messages.append(message)
            strongSelf.tableView.reloadData()
            strongSelf.scrollToBottom()
        }
        
        socket.connect()
        _ = lobby.join()
            .receive("ok", callback: { _ in
                print("lobby connected")
            })
            .receive("error", callback: { error in
                print("lobby error: \(error)")
            })
            .receive("timeout", callback: { error in
                print("lobby timeout: \(error)")
            })
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
    
    // MARK: send message
    
    @objc private func sendMessage(_ sender: Any?) {
        guard let text = chatBox.textField.text, !text.isEmpty else { return }
        
        let params = [
            Message.CodingKeys.pollId.rawValue: poll.id,
            Message.CodingKeys.optionId.rawValue: option.id,
            Message.CodingKeys.message.rawValue: text,
            "user_id": UserHolder.shared.user.id
        ]
        
        _ = lobby.push(Constants.Channel.shout, payload: params)
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
    
    // MARK: text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatBox.sendButton.isLoading = true
        
        sendMessage(chatBox.sendButton)
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: helper
    
    private func scrollToBottom() {
        let indexPath = IndexPath(row: 0, section: messages.count-1)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func updateSendColor() {
        if let index = poll.options.firstIndex(of: option) {
            chatBox.sendButton.backgroundColor = .pollColor(index: index)
        }
    }
    
    // MARK: keyboard notifications
    
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                if UIApplication.shared.statusBarOrientation.isPortrait {
                    self.chatBox.snp.remakeConstraints { make in
                        self.defaultTextFieldConstraints(make)
                        make.bottom.equalTo(self.view.snp.bottom).offset(-keyboardSize.height)
                    }
                }
                
                UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            self.chatBox.snp.remakeConstraints { make in
                self.defaultTextFieldConstraints(make)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-4.0)
            }
            
            UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
