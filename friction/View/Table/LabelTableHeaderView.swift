//
//  LabelTableHeaderView.swift
//  friction
//
//  Created by Tim Wong on 3/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class LabelTableHeaderView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 18.0)
        label.textColor = .black
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
        addSubview(label)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        label.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        super.updateConstraints()
    }
}
