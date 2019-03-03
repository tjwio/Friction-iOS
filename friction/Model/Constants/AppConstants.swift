//
//  AppConstants.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

typealias UserHandler = (User) -> Void

typealias PollHandler = (Poll) -> Void
typealias PollListHandler = ([Poll]) -> Void

typealias VoteHandler = (Vote) -> Void
typealias VoteListHandler = ([Vote]) -> Void

typealias MessageHandler = (Message) -> Void
typealias MessageListHandler = ([Message]) -> Void

typealias ClapHandler = (Message.Clap) -> Void
typealias ClapListHandler = ([Message.Clap]) -> Void

typealias DislikeHandler = (Message.Dislike) -> Void
typealias DislikeListHandler = ([Message.Dislike]) -> Void

typealias DeviceTokenHandler = (DeviceToken) -> Void

typealias ImageHandler = (UIImage) -> Void

typealias JSONHandler = (JSON) -> Void
typealias JSONListHandler = ([JSON]) -> Void
typealias ErrorHandler = (Error) -> Void
typealias EmptyHandler = () -> Void

struct AppConstants {
    struct UserDefaults {
        static let tokenKey = "device_token"
    }
}
