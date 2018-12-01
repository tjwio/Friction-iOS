//
//  NetworkHandler+Votes.swift
//  friction
//
//  Created by Tim Wong on 11/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

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
}
