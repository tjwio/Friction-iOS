//
//  ProgressView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    class LabelView: UIView {
        let label: UILabel = {
            let label = UILabel()
            label.font = .avenirBold(size: 10.0)
            label.textColor = .white
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
                make.center.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
    
    var percents = [Double]() {
        didSet {
            reloadProgressViews()
        }
    }
    
    var labelsHidden = false
    
    private var progressViews = [(UIView, Double)]()
    
    init() {
        super.init(frame: .zero)
    }
    
    init(labelsHidden: Bool) {
        self.labelsHidden = labelsHidden
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        var previousView: UIView?
        
        for (index, (view, width)) in progressViews.enumerated() {
            let isLast = index == progressViews.count - 1
            
            view.snp.makeConstraints { make in
                if let previousView = previousView {
                    make.leading.equalTo(previousView.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                
                make.top.bottom.equalToSuperview()
                
                if !isLast {
                    make.width.equalToSuperview().multipliedBy(width)
                }
            }
            
            previousView = view
        }
        
        previousView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func reloadProgressViews() {
        progressViews.forEach { $0.0.removeFromSuperview() }
        
        var index = 0
        progressViews = percents.map { percent in
            let view = LabelView()
            view.backgroundColor = .pollColor(index: index)
            view.label.isHidden = self.labelsHidden
            view.label.text = "\(Int(percent * 100.0))%"
            view.translatesAutoresizingMaskIntoConstraints = false
            
            index += 1;
            
            return (view, percent)
        }
        
        progressViews.forEach { self.addSubview($0.0) }
        
        setNeedsUpdateConstraints()
    }
}
