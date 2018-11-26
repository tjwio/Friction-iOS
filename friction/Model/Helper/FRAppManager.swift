//
//  FRAppManager.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

enum FREnvironment {
    case development, staging, production
    
    var apiUrl: String {
        return "http://localhost:4000/api/v1"
    }
    
    var streamUrl: String {
        return "ws://localhost:4000/socket/websocket"
    }
}

class FRAppManager: NSObject {
    static private(set) var shared = FRAppManager(environment: .production)
    
    private(set) var environment: FREnvironment
    
    private init(environment: FREnvironment) {
        self.environment = environment
        super.init()
    }
    
    class func initialize(environment: FREnvironment) -> FRAppManager {
        shared = FRAppManager(environment: environment)
        
        return shared
    }
    
    func logOut() {
        
    }
}
