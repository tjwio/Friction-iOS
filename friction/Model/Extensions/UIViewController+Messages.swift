//
//  UIViewController+Messages.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import GSMessages

extension UIViewController {
    public func showLeftMessage(_ text: String, type: GSMessageType, options: [GSMessageOption]? = nil, view: UIView? = nil) {
        var optionsToSend = [GSMessageOption]()
        optionsToSend.append(.textAlignment(.left))
        optionsToSend.append(.textPadding(16.0))
        optionsToSend.append(.height(44.0))
        if let options = options {
            optionsToSend.append(contentsOf: options)
        }
        
        GSMessage.showMessageAddedTo(text, type: type, options: optionsToSend, inView: view ?? self.view, inViewController: self)
    }
}
