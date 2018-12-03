//
//  HistoryPollTableViewCell.swift
//  friction
//
//  Created by Tim Wong on 11/28/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class HistoryPollTableViewCell: BasePollTableViewCell {
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
        }
        
        avatarStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        super.updateConstraints()
    }
}
