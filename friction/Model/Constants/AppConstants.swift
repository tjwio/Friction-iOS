//
//  AppConstants.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

public typealias JSON = [String : Any]

public typealias UserHandler = (User) -> Void

public typealias JSONHandler = (JSON) -> Void
public typealias JSONListHandler = ([JSON]) -> Void
public typealias ErrorHandler = (Error) -> Void
