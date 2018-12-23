//
//  StatLabelView.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class StatLabelView: UIView {
    let statView: StatView
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 12.0)
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(counts: [Int], name: String) {
        statView = StatView(counts: counts, name: name)
        label.text = "Total ".appending(name)
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(label)
        addSubview(statView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        statView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom).offset(12.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
