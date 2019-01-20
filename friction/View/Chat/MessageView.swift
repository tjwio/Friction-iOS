//
//  MessageView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class MessageView: UIView {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 10.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let doubleSlashLabel: UILabel = {
        let label = UILabel()
        label.text = "//"
        label.font = .avenirLight(size: 10.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 10.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 14.0)
        label.numberOfLines = 0
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, doubleSlashLabel, timeLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
        
        addSubview(labelStackView)
        addSubview(messageLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-8.0)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.labelStackView.snp.bottom).offset(4.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        super.updateConstraints()
    }
}
