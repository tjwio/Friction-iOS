//
//  AppManager.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

enum Environment {
    case development, staging, production
    
    var apiUrl: String {
        return "https://friction-elixir.herokuapp.com/api/v1"
    }
    
    var streamUrl: String {
        return "wss://friction-elixir.herokuapp.com/socket/websocket"
    }
}

class AppManager: NSObject {
    static private(set) var shared = AppManager(environment: .production)
    
    private(set) var environment: Environment
    
    private init(environment: Environment) {
        self.environment = environment
        super.init()
    }
    
    class func initialize(environment: Environment) -> AppManager {
        shared = AppManager(environment: environment)
        
        return shared
    }
    
    func logOut() {
        AuthenticationManager.shared.logOut()
        (UIApplication.shared.delegate as? AppDelegate)?.loadMainViewController()
    }
}
