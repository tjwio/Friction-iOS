//
//  User.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

public class User: NSObject, Decodable {
    var id: String
    var email: String
    var name: String
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case imageUrl = "image_url"
    }
}
