//
//  AppConstants.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

typealias UserHandler = (User) -> Void

typealias PollHandler = (Poll) -> Void
typealias PollListHandler = ([Poll]) -> Void

typealias VoteHandler = (Vote) -> Void
typealias VoteListHandler = ([Vote]) -> Void

typealias JSONHandler = (JSON) -> Void
typealias JSONListHandler = ([JSON]) -> Void
typealias ErrorHandler = (Error) -> Void
typealias EmptyHandler = () -> Void
