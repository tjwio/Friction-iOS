//
//  LiveChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit
import SwiftPhoenixClient

class LiveChatViewController: BaseChatViewController, ButtonScrollViewDelegate, UITextFieldDelegate {

    private struct Constants {
        struct Channel {
            static let lobby = "room:lobby"
            static let shout = "shout"
            static let claps = "claps"
            static let dislikes = "dislikes"
        }
    }
    
    let socket = Socket(AppManager.shared.environment.streamUrl, params: ["token" : AuthenticationManager.shared.authToken ?? ""])
    var lobby: Channel!
    
    override var option: Poll.Option {
        didSet {
            updateSendColor()
        }
    }
    
    let chatBox: ChatBoxView = {
        let view = ChatBoxView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var baseTextFieldConstraints: (SnapKit.ConstraintMaker) -> Void = { make in
        make.leading.equalToSuperview().offset(16.0)
        make.trailing.equalToSuperview().offset(-16.0)
        make.height.equalTo(52.0)
    }
    
    var didJustSendMessage = false
    
    deinit {
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonScrollView.selectionDelegate = self
        
        chatBox.textField.delegate = self
        chatBox.sendButton.addTarget(self, action: #selector(self.sendMessage(_:)), for: .touchUpInside)
        
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: tableView.contentInset.left, bottom: 62.0, right: tableView.contentInset.right)
        tableView.keyboardDismissMode = .onDrag
        
        updateSendColor()
        addSocketEvents()
        
        view.addSubview(chatBox)
        view.addSubview(whiteView)
        
        whiteView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        chatBox.snp.makeConstraints { make in
            self.baseTextFieldConstraints(make)
            make.bottom.equalTo(self.whiteView.snp.top)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        lobby.on(Constants.Channel.shout) { [unowned self] message in
            if self.chatBox.sendButton.isLoading {
                self.chatBox.textField.text = ""
                self.chatBox.sendButton.isLoading = false
            }
            guard let message = message.payload.decodeJson(Message.self) else { return }
            self.poll.messages.append(message)
            self.tableView.reloadData()
            self.scrollToBottom()
        }
        
        lobby.on(Constants.Channel.claps) { [weak self] message in
            guard let strongSelf = self,
                let id = message.payload[Message.CodingKeys.id.rawValue] as? String, let claps = message.payload[Message.CodingKeys.claps.rawValue] as? Int,
                let index = strongSelf.poll.messages.firstIndex(where: { return $0.id == id }) else { return }
            
            let origMessage = strongSelf.poll.messages[index]
            guard !origMessage.isPendingClaps && origMessage.claps != claps else { return }
            
            origMessage.claps = claps
            
            strongSelf.tableView.reloadSections(IndexSet(integer: index), with: .none)
        }
        
        lobby.on(Constants.Channel.dislikes) { [weak self] message in
            guard let strongSelf = self,
                let id = message.payload[Message.CodingKeys.id.rawValue] as? String, let dislikes = message.payload[Message.CodingKeys.dislikes.rawValue] as? Int,
                let index = strongSelf.poll.messages.firstIndex(where: { return $0.id == id }) else { return }
            
            let origMessage = strongSelf.poll.messages[index]
            guard !origMessage.isPendingDislikes && origMessage.dislikes != dislikes else { return }
            
            origMessage.dislikes = dislikes
            
            strongSelf.tableView.reloadSections(IndexSet(integer: index), with: .none)
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
    
    // MARK: send message
    
    @objc private func sendMessage(_ sender: Any?) {
        guard let text = chatBox.textField.text, !text.isEmpty else { (sender as? LoadingButton)?.isLoading = false; return }
        
        self.didJustSendMessage = true
        
        let params = [
            Message.CodingKeys.pollId.rawValue: poll.id,
            Message.CodingKeys.optionId.rawValue: option.id,
            Message.CodingKeys.message.rawValue: text,
            "user_id": UserHolder.shared.user.id
        ]
        
        _ = lobby.push(Constants.Channel.shout, payload: params)
    }
    
    // MARK: button selection
    
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
    
    // MARK: table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let message = poll.messages[indexPath.section]
        
        if let cell = cell as? FullMessageTableViewCell {
            cell.clapView.isUserInteractionEnabled = true
            cell.dislikeView.isUserInteractionEnabled = true
            
            cell.clapView.maxClaps = 50 - (message.addedClap?.claps ?? 0)
            cell.dislikeView.maxClaps = 50 - (message.addedDislike?.dislikes ?? 0)
            
            cell.clapCallback = { [weak message] claps in
                message?.addClaps(claps, success: nil, failure: nil)
            }
            cell.dislikeCallback = { [weak message] dislikes in
                message?.addDislikes(dislikes, success: nil, failure: nil)
            }
        }
        
        return cell
    }
    
    // MARK: text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatBox.sendButton.isLoading = true
        
        sendMessage(chatBox.sendButton)
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: helper
    
    private func updateSendColor() {
        if let index = poll.options.firstIndex(of: option) {
            chatBox.sendButton.backgroundColor = .pollColor(index: index)
        }
    }
    
    override func messagesDidReload(_ messages: [Message]) {
        self.scrollToBottom()
    }
    
    // MARK: keyboard notifications
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if chatBox.textField.isFirstResponder {
            chatBox.textField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                if UIApplication.shared.statusBarOrientation.isPortrait {
                    self.chatBox.snp.remakeConstraints { make in
                        self.baseTextFieldConstraints(make)
                        make.bottom.equalTo(self.view.snp.bottom).offset(-keyboardSize.height)
                    }
                }
                
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0+keyboardSize.height, right: 0.0)
                
                UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.tableView.contentInset = contentInsets
                    self.tableView.scrollIndicatorInsets = contentInsets
                    self.tableView.setNeedsDisplay()
                    self.view.layoutIfNeeded()
                    self.scrollToBottom()
                }, completion: nil)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            self.chatBox.snp.remakeConstraints { make in
                self.baseTextFieldConstraints(make)
                make.bottom.equalTo(self.whiteView.snp.top)
            }
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 62.0, right: 0.0)
            
            UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, animations: {
                self.tableView.contentInset = contentInsets
                self.tableView.scrollIndicatorInsets = contentInsets
                self.tableView.setNeedsDisplay()
                self.view.layoutIfNeeded()
                
                if self.didJustSendMessage {
                    self.scrollToBottom()
                    self.didJustSendMessage = false
                }
            })
        }
    }
}
