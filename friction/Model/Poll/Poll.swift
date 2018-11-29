//
//  Poll.swift
//  friction
//
//  Created by Tim Wong on 11/28/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

class PollOption: NSObject, Decodable {
    var id: String
    var name: String
    var votes: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, votes
    }
}

class Poll: NSObject, Decodable {
    var id: String
    var name: String
    var options: [PollOption]
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
        options = try container.decode([PollOption].self, forKey: .options)
        
        let dateStr = try container.decode(String.self, forKey: .date)
        
        if let date = DateFormatter.iso861.date(from: dateStr) {
            self.date = date
        } else {
            throw CommonError.invalidJson
        }
    }
}
