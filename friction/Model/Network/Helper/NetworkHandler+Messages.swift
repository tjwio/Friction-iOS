//
//  NetworkHandler+Messages.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

extension NetworkHandler {
    func addClaps(messageId: String, parameters: Parameters, success: EmptyHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addClaps(messageId: messageId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success: success?()
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func addDislikes(messageId: String, parameters: Parameters, success: EmptyHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addDislikes(messageId: messageId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success: success?()
            case .failure(let error): failure?(error)
            }
        }
    }
}
