//
//  VotePollTableViewCell.swift
//  friction
//
//  Created by Tim Wong on 11/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class LivePollTableViewCell: BasePollTableViewCell {
    let liveView: LiveView = {
        let view = LiveView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let rightArrow: UIImageView = {
        let imageView = UIImageView(image: .rightChevron)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let discussLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 12.0)
        label.text = GlobalStrings.discuss.localized.uppercased()
        label.textColor = UIColor.Grayscale.light
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func commonInit() {
        contentView.addSubview(liveView)
        contentView.addSubview(rightArrow)
        contentView.addSubview(discussLabel)
        
        super.commonInit()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        liveView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-16.0)
        }
        
        discussLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.rightArrow.snp.leading).offset(-6.0)
            make.centerY.equalTo(self.rightArrow)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
        }
        
        avatarStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24.0)
        }
        
        super.updateConstraints()
    }
}
