//
//  ChatBoxView.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class ChatBoxView: UIView {
    let textField: ChatTextField = {
        let textField = ChatTextField()
        textField.borderStyle = .none
        textField.font = .avenirRegular(size: 16.0)
        textField.layer.borderColor = UIColor.Grayscale.light.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 22.0
        textField.placeholder = "Type a message..."
        textField.textColor = UIColor.Grayscale.dark
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
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
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        
        addSubview(textField)
        addSubview(sendButton)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0))
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30.0)
        }
        
        super.updateConstraints()
    }
}
