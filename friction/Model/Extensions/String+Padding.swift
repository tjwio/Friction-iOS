//
//  String+Padding.swift
//  friction
//
//  Created by Tim Wong on 1/26/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
