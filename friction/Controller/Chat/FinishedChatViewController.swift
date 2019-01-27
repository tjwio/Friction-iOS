//
//  FinishedChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class FinishedChatViewController: BaseChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonScrollView.enabled = false
        liveView.isHidden = true
    }
    
    override func messagesDidReload(_ messages: [Message]) {
        let messages = poll.options.map { return $0.messages }
        
        let counts = messages.map { $0.count }
        let claps = messages.map { $0.map { $0.claps }.reduce(0, +) }
        let dislikes = messages.map { $0.map { $0.dislikes }.reduce(0, +) }
        
        let header = StatsHolderView(items: [(count: counts, name: "Comments"),
                                             (count: claps, name: "Claps"),
                                             (count: dislikes, name: "Dislikes")])
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableView.tableHeaderView = header
        tableView.layoutIfNeeded()
    }
}
