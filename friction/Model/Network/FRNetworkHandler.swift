//
//  FRNetworkHandler.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

final class FRNetworkHandler: NSObject {
    static let shared = FRNetworkHandler()
    private(set) var sessionManager = SessionManager(configuration: .default)
    
    private override init() { super.init() }
}
