//
//  FRAppConstants.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

public typealias JSON = [String : Any]

public typealias FRUserHandler = (FRUser) -> Void

public typealias FRJSONHandler = (JSON) -> Void
public typealias FRJSONListHandler = ([JSON]) -> Void
public typealias FRErrorHandler = (Error) -> Void
