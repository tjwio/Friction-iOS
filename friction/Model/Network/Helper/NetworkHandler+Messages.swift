//
//  NetworkHandler+Messages.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

extension NetworkHandler {
    func addClaps(messageId: String, parameters: Parameters, success: ClapHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addClaps(messageId: messageId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let clap = response.data?.decodeJson(Message.Clap.self) {
                    success?(clap)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func updateClaps(messageId: String, clapId: String, parameters: Parameters, success: ClapHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.updateClaps(messageId: messageId, clapId: clapId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let clap = response.data?.decodeJson(Message.Clap.self) {
                    success?(clap)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func addDislikes(messageId: String, parameters: Parameters, success: DislikeHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addDislikes(messageId: messageId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let dislike = response.data?.decodeJson(Message.Dislike.self) {
                    success?(dislike)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func updateDislikes(messageId: String, dislikeId: String, parameters: Parameters, success: DislikeHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.updateDislikes(messageId: messageId, dislikeId: dislikeId, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let dislike = response.data?.decodeJson(Message.Dislike.self) {
                    success?(dislike)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
}
