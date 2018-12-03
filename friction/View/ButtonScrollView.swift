//
//  ButtonScrollView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

protocol ButtonScrollViewDelegate: class {
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelect item: (value: String, percent: Double, selected: Bool), at index: Int)
}

class ButtonScrollView: UIScrollView {
    
    struct Constants {
        struct Button {
            static let height = 44.0
            static let width = 125.0
        }
    }
    
    weak var selectionDelegate: ButtonScrollViewDelegate?
    
    var items = [(value: String, percent: Double, selected: Bool)]() {
        didSet {
            reloadButtons()
        }
    }
    
    var buttons = [PercentageButton]()
    
    var showPercentage = true
    
    // MARK: button scroll view
    
    private func reloadButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        guard !items.isEmpty else { return }
        
        var item = items.first!
        var prevButton = PercentageButton(value: item.value, count: Int(item.percent * 100.0), color: .pollColor(index: 0), selected: item.selected, showPercentage: showPercentage)
        prevButton.tag = 0
        buttons.append(prevButton)
        addSubview(prevButton)
        
        prevButton.addTarget(self, action: #selector(self.didSelectButton(_:)), for: .touchUpInside)
        
        prevButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(Constants.Button.width)
            make.height.equalTo(Constants.Button.height)
        }
        
        for index in 1..<items.endIndex {
            item = items[index]
            let nextButton = PercentageButton(value: item.value, count: Int(item.percent * 100.0), color: .pollColor(index: index % 3), selected: item.selected, showPercentage: showPercentage)
            nextButton.tag = index
            nextButton.addTarget(self, action: #selector(self.didSelectButton(_:)), for: .touchUpInside)
            buttons.append(nextButton)
            addSubview(nextButton)
            
            nextButton.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(prevButton.snp.trailing).offset(12.0)
                make.width.equalTo(Constants.Button.width)
                make.height.equalTo(Constants.Button.height)
            }
            
            prevButton = nextButton
        }
        
        prevButton.snp.makeConstraints { make in
            make.trailing.greaterThanOrEqualToSuperview()
        }
        
        setNeedsLayout()
    }
    
    // MARK: button helper
    
    @objc private func didSelectButton(_ sender: PercentageButton) {
        if items[sender.tag].selected {
            sender.isLoading = false
        } else {
            selectionDelegate?.buttonScrollView(self, didSelect: items[sender.tag], at: sender.tag)
        }
    }
}
