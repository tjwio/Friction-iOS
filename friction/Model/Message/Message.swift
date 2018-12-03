//
//  Message.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

struct Message: Decodable {
    var id: String
    
    var poll: Poll
    var option: Poll.Option
    
    var message: String
    var claps: Int
    
    var name: String
    var imageUrl: String?
    
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, message, claps, name
        case pollId = "poll_id"
        case optionId = "option_id"
        case imageUrl = "image_url"
        case date = "inserted_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        message = try container.decode(String.self, forKey: .message)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        claps = try container.decode(Int.self, forKey: .claps)
        let pollId = try container.decode(String.self, forKey: .pollId)
        let optionId = try container.decode(String.self, forKey: .optionId)
        let dateStr = try container.decode(String.self, forKey: .date)
        guard let poll = PollHolder.shared.getPoll(id: pollId), let option = poll.getOption(id: optionId), let date = DateFormatter.iso861.date(from: dateStr) else {
            throw CommonError.invalidJson
        }
        self.poll = poll
        self.option = option
        self.date = date
    }
}
