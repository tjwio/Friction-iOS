//
//  Token.swift
//  friction
//
//  Created by Tim Wong on 12/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

struct DeviceToken: Decodable {
    var id: String
    var udid: String
    var token: String
    var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, udid, token
        case userId = "user_id"
    }
}
