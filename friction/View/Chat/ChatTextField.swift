//
//  ChatTextField.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon

class ChatTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16.0, dy: 0.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16.0, dy: 0.0)
    }
}
