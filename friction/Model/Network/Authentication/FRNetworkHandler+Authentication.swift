//
//  FRNetworkHandler+Authentication.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

extension FRNetworkHandler {
    
    private struct Constants {
        static let password = "password"
    }
    
    public func signup(name: String, email: String, password: String, success: FRJSONHandler?, failure: FRErrorHandler?) {
        let parameters = [
            FRUser.CodingKeys.name.rawValue: name,
            FRUser.CodingKeys.email.rawValue: email,
            Constants.password: password
        ]
        
        self.sessionManager.request(FRURLRouter.signup(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public func login(email: String, password: String, success: FRJSONHandler?, failure: FRErrorHandler?) {
        let parameters = [
            FRUser.CodingKeys.email.rawValue: email,
            Constants.password: password
        ]
        
        self.sessionManager.request(FRURLRouter.login(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
