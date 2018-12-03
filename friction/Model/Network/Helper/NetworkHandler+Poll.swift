//
//  NetworkHandler+Poll.swift
//  friction
//
//  Created by Tim Wong on 11/28/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension NetworkHandler {
    func getPolls(success: PollListHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.getPolls).validate().responseData { response in
            switch response.result {
            case .success:
                if let polls = response.data?.decodeJson([Poll].self) {
                    success?(polls)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func getMessages(pollId: String, success: MessageListHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.getMessages(pollId: pollId)).validate().responseData { response in
            switch response.result {
            case .success:
                if let messages = response.data?.decodeJson([Message].self) {
                    success?(messages)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
}
