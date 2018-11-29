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
    
    enum CodingKeys: String, CodingKey {
        case id, name, options
    }
}
