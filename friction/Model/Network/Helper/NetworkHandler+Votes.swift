//
//  NetworkHandler+Votes.swift
//  friction
//
//  Created by Tim Wong on 11/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkHandler {
    func getAllVotes(success: VoteListHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.getAllVotes).validate().responseData { response in
            switch response.result {
            case .success:
                if let polls = response.data?.decodeJson([Vote].self) {
                    success?(polls)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func addVote(parameters: Parameters, success: VoteHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addVote(parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let poll = response.data?.decodeJson(Vote.self) {
                    success?(poll)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
    
    func updateVote(id: String, parameters: Parameters, success: VoteHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.updateVote(id: id, parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let poll = response.data?.decodeJson(Vote.self) {
                    success?(poll)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
}
