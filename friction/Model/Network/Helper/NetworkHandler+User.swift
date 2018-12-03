//
//  NetworkHandler+User.swift
//  friction
//
//  Created by Tim Wong on 12/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkHandler {
    func getUser(success: UserHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.loadUser).validate().responseData { response in
            switch response.result {
            case .success:
                if let user = response.data?.decodeJson(User.self) {
                    success?(user)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func updateUser(parameters: Parameters, success: EmptyHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.updateUser(parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success: success?()
            case .failure(let error): failure?(error)
            }
        }
    }
}
