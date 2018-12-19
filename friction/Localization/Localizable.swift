//
//  Localizable.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

enum GlobalStrings: String, Localizable {
    case at = "at"
    case claps = "claps"
    case discuss = "discuss"
    case editProfile = "edit_profile"
    case email = "email"
    case fullName = "full_name"
    case live = "live"
    case todaysClash = "todays_clash"
    case todaysClashChat = "todays_clash_chat"
    case typeMessage = "type_message"
    case votes = "votes"
    
    var tableName: String {
        return "Global"
    }
}
