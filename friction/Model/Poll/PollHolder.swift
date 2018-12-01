//
//  PollHolder.swift
//  friction
//
//  Created by Tim Wong on 11/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

class PollHolder: NSObject {
    static let shared = PollHolder()
    
    var polls = [Poll]()
    private var pollMap = [String: Poll]()
    
    func initialLoad(success: PollListHandler?, failure: ErrorHandler?) {
        loadPolls(success: { polls in
            self.loadVotes(success: {
                success?(polls)
            }, failure: failure)
        }, failure: failure)
    }
    
    func loadPolls(success: PollListHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.getPolls(success: { polls in
            self.polls = polls
            polls.forEach { self.pollMap[$0.id] = $0 }
            success?(polls)
        }) { error in
            self.polls = []
            failure?(error)
        }
    }
    
    func loadVotes(success: EmptyHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.getAllVotes(success: { votes in
            for vote in votes {
                self.pollMap[vote.pollId]?.getOption(id: vote.optionId)?.vote = vote
            }
            success?()
        }, failure: failure)
    }
}
