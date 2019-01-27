//
//  FinishedChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class FinishedChatViewController: BaseChatViewController {
    
    var header: StatsHolderView?
    
    var chartItems: [(count: [Int], name: String)] {
        let messages = poll.options.map { return $0.messages }
        
        let counts = messages.map { $0.count }
        let claps = messages.map { $0.map { $0.claps }.reduce(0, +) }
        let dislikes = messages.map { $0.map { $0.dislikes }.reduce(0, +) }
        
        return [(count: counts, name: "Comments"),
                (count: claps, name: "Claps"),
                (count: dislikes, name: "Dislikes")]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonScrollView.enabled = false
        liveView.isHidden = true
        
        let header = StatsHolderView(items: chartItems)
        self.header = header
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard tableView.tableHeaderView == nil, let header = header else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if size.height != 0 {
            header.frame.size.height = size.height
            
            tableView.tableHeaderView = header
            tableView.layoutIfNeeded()
        }
    }
    
    override func messagesDidReload(_ messages: [Message]) {
        header?.items = chartItems
    }
}
