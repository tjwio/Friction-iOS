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
    var items: [(count: [Int], name: String)] {
        didSet {
            stackView.removeFromSuperview()
            updateItems(items)
        }
    }
    
    var statViews = [StatLabelView]()
    var stackView: UIStackView!
    
    init(items: [(count: [Int], name: String)]) {
        self.items = items
        super.init(frame: .zero)
        updateItems(items)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(stackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12.0)
        }
        
        statViews.forEach { $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
    
    private func updateItems(_ items: [(count: [Int], name: String)]) {
        statViews = items.map { return StatLabelView(counts: $0.count, name: $0.name) }
        stackView = UIStackView(arrangedSubviews: statViews)
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        setNeedsUpdateConstraints()
    }
}
