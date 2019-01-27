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
        
        let messages = poll.options.map { return $0.messages }
        
        let counts = messages.map { $0.count }
        let claps = messages.map { $0.map { $0.claps }.reduce(0, +) }
        let dislikes = messages.map { $0.map { $0.dislikes }.reduce(0, +) }
        
        let header = StatsHolderView(items: [(count: counts, name: "Comments"),
                                             (count: claps, name: "Claps"),
                                             (count: dislikes, name: "Dislikes")])
        tableView.tableHeaderView = header
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            
            tableView.tableHeaderView = headerView
            
            tableView.layoutIfNeeded()
        }
    }
}
