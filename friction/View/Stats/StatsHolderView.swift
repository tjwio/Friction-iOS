//
//  StatsHolderView.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class StatsHolderView: UIView {
    let items: [(count: [Int], name: String)]
    
    let statViews: [StatLabelView]
    let stackView: UIStackView
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 22.0)
        label.text = "Stats"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(items: [(count: [Int], name: String)]) {
        self.items = items
        statViews = items.map { return StatLabelView(counts: $0.count, name: $0.name) }
        stackView = UIStackView(arrangedSubviews: statViews)
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(label)
        addSubview(stackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
