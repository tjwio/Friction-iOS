//
//  NetworkHandler.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

final class NetworkHandler: NSObject {
    static let shared = NetworkHandler()
    private(set) var sessionManager = Session(configuration: .default)
    
    private override init() { super.init() }
}
