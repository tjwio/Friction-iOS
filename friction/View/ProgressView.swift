//
//  ProgressView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var percents = [Double]() {
        didSet {
            reloadProgressViews()
        }
    }
    
    let firstProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let secondProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let thirdProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        addSubview(firstProgressView)
        addSubview(secondProgressView)
        addSubview(thirdProgressView)
    }
    
    private func reloadProgressViews() {
        let firstWidth = percents.isEmpty ? 0.0 : percents[0]
        let secondWidth = percents.count >= 2 ? percents[1] : 0.0
        let thirdWidth = percents.count >= 3 ? percents[2] : 0.0
        
        firstProgressView.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalToSuperview().multipliedBy(firstWidth)
        }
        
        secondProgressView.snp.remakeConstraints { make in
            make.leading.equalTo(self.firstProgressView.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(secondWidth)
        }
        
        thirdProgressView.snp.remakeConstraints { make in
            make.leading.equalTo(self.secondProgressView.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(thirdWidth)
        }
    }
}
