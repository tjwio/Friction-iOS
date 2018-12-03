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
    
    let sendButton: LoadingButton = {
        let button = LoadingButton(type: .custom)
        button.backgroundColor = .pollColor(index: 0)
        button.layer.cornerRadius = 15.0
        button.setTitle(String.featherIcon(name: .arrowUp), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.featherFont(size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(sendButton)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30.0)
        }
        
        super.updateConstraints()
    }
}
