//
//  DateFormatter+Constants.swift
//  friction
//
//  Created by Tim Wong on 11/29/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension DateFormatter {
    static private let iso861Format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }()
    
    static private let dayFullMonthFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = .current
        
        return formatter
    }()
    
    class var iso861: DateFormatter {
        return DateFormatter.iso861Format
    }
    
    class var dayFullMonth: DateFormatter {
        return dayFullMonthFormat
    }
}
