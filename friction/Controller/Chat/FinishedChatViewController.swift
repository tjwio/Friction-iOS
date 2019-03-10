//
//  FinishedChatViewController.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class FinishedChatViewController: BaseChatViewController {
    
    var topComments = [Message]()
    var bottomComments = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonScrollView.enabled = false
        liveView.isHidden = true
    }
    
    override func messagesDidReload(_ messages: [Message]) {
        let optionMessages = poll.options.map { return $0.messages }
        
        let counts = optionMessages.map { $0.count }
        let claps = optionMessages.map { $0.map { $0.claps }.reduce(0, +) }
        let dislikes = optionMessages.map { $0.map { $0.dislikes }.reduce(0, +) }
        
        let clapsSorted = messages.sorted { $0.claps > $1.claps }
        let dislikesSorted = messages.sorted { $0.dislikes > $1.dislikes }
        let num = min(messages.count / 2, 5)

        bottomComments = Array(dislikesSorted[0..<num])
        topComments = Array(clapsSorted[0..<num])
        
        tableView.reloadData()
        
        let header = StatsHolderView(items: [(count: counts, name: "Comments"),
                                             (count: claps, name: "Claps"),
                                             (count: dislikes, name: "Dislikes")],
                                     labels: poll.options.map { $0.name })
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableView.tableHeaderView = header
        tableView.layoutIfNeeded()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activityIndicator.isAnimating ? 0 : poll.messages.count + topComments.count + bottomComments.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == topComments.count || section == topComments.count + bottomComments.count ? 40.0 : super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == topComments.count || section == topComments.count + bottomComments.count {
            let header = LabelTableHeaderView()
            header.backgroundColor = .white
            
            if section == topComments.count + bottomComments.count {
                header.label.text = "All Comments"
            } else if section == 0 {
                header.label.text = "Most Clapped Comments"
            } else if section == topComments.count {
                header.label.text = "Most Hated Comments"
            }
            
            return header
        } else {
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == topComments.count - 1 || section == topComments.count + bottomComments.count - 1 ? 8.0 : 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: Message
        
        if indexPath.section >= topComments.count + bottomComments.count {
            message = poll.messages[indexPath.section - (topComments.count + bottomComments.count)]
        } else if indexPath.section < topComments.count {
            message = topComments[indexPath.section]
        } else {
            message = bottomComments[indexPath.section - topComments.count]
        }
        
        return getCell(tableView: tableView, message: message)
    }
}
