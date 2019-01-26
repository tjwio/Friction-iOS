//
//  MessageView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class MessageView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 14.0)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        layer.cornerRadius = 12.0
        
        addSubview(messageLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        super.updateConstraints()
    }
}
