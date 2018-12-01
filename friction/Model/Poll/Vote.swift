//
//  Vote.swift
//  friction
//
//  Created by Tim Wong on 11/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

struct Vote: Decodable {
    var id: String
    var pollId: String
    var optionId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case pollId = "poll_id"
        case optionId = "option_id"
    }
}
