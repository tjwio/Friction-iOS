//
//  Data+JSON.swift
//  Restaurant
//
//  Created by Tim Wong on 5/17/18.
//  Copyright © 2018 myDevices. All rights reserved.
//

import Foundation

extension Data {
    public func decodeJson<T>(_ type: T.Type) -> T? where T: Decodable {
        if let response = try? JSONDecoder().decode(type, from: self) {
            return response
        }

        return nil
    }
}
