//
//  PercentageButton.swift
//  friction
//
//  Created by Tim Wong on 11/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class PercentageButton: UIButton {
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 8.0)
        label.textColor = UIColor.Grayscale.dark
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
    
    convenience init(value: String, count: Int, color: UIColor, selected: Bool = false) {
        self.init()
        setTitle(value, for: .normal)
        percentLabel.text = "\(count)%"
        
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        
        if selected {
            backgroundColor = color
        } else {
            backgroundColor = .white
        }
    }
    
    private func commonInit() {
        layer.cornerRadius = 2.0
        
        addSubview(percentLabel)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        percentLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
