//
//  FRError.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

enum FRError: Error {
    case imageData
    case invalidJson
    case nilOrEmpty
    
    var localizedDescription: String {
        switch self {
        case .imageData:
            return "Failed to encode image data"
        case .invalidJson:
            return "Invalid JSON Response"
        case .nilOrEmpty:
            return "Response was nil or empty"
        }
    }
}
