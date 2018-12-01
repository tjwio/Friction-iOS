//
//  Poll.swift
//  friction
//
//  Created by Tim Wong on 11/28/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

class Poll: NSObject, Decodable {
    class Option: NSObject, Decodable {
        var id: String
        var name: String
        var votes: Int
        var vote: Vote?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case votes = "vote_count"
        }
    }
    
    var id: String
    var name: String
    var options: [Option]
    var date: Date
    
    var totalVotes: Int {
        return options.reduce(0, { (result, option) -> Int in
            return result + option.votes
        })
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, options
        case date = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        options = try container.decode([Option].self, forKey: .options)
        
        let dateStr = try container.decode(String.self, forKey: .date)
        
        if let date = DateFormatter.iso861.date(from: dateStr) {
            self.date = date
        } else {
            throw CommonError.invalidJson
        }
    }
    
    // MARK: vote
    
    func vote(option: Option, success: VoteHandler?, failure: ErrorHandler?) {
        if let origOption = options.first(where: { return $0.vote != nil }) {
            updateVote(origOption.vote!, newOption: option, originalOption: origOption, success: success, failure: failure)
        } else {
            addVote(option: option, success: success, failure: failure)
        }
    }
    
    private func addVote(option: Option, success: VoteHandler?, failure: ErrorHandler?) {
        let params = [
            Vote.CodingKeys.pollId.rawValue: id,
            Vote.CodingKeys.optionId.rawValue : option.id
        ]
        
        NetworkHandler.shared.addVote(parameters: params, success: { vote in
            option.vote = vote
            option.votes += 1
            success?(vote)
        }, failure: failure)
    }
    
    private func updateVote(_ vote: Vote, newOption: Option, originalOption: Option, success: VoteHandler?, failure: ErrorHandler?) {
        let params = [
            Vote.CodingKeys.pollId.rawValue: id,
            Vote.CodingKeys.optionId.rawValue : newOption.id
        ]
        
        NetworkHandler.shared.updateVote(id: vote.id, parameters: params, success: { vote in
            originalOption.vote = nil
            originalOption.votes -= 1
            newOption.vote = vote
            newOption.votes += 1
            success?(vote)
        }, failure: failure)
    }
    
    // MARK: helper
    
    func getOption(id: String) -> Option? {
        return options.first { return $0.id == id }
    }
}
