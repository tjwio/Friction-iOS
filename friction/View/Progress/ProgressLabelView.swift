//
//  ProgressLabelView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ProgressLabelView: UIView {
    
    var percents = [Double]() {
        didSet {
            progressView.percents = percents
            
            if percents.count >= 1 {
                firstLabel.text = "\(Int(percents[0] * 100.0))%"
            } else {
                firstLabel.isHidden = percents.isEmpty
            }
            
            if percents.count >= 2 {
                secondLabel.text = "\(Int(percents[1] * 100.0))%"
            } else {
                secondLabel.isHidden = percents.count < 2
            }
            
            if percents.count >= 3 {
                thirdLabel.text = "\(Int(percents[2] * 100.0))%"
            } else {
                thirdLabel.isHidden = percents.count < 3
            }
        }
    }
    
    private let progressView: ProgressView = {
        let progressView = ProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 10.0)
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 10.0)
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let thirdLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 10.0)
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
    
    private func commonInit() {
        addSubview(progressView)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(thirdLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(8.0)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(2.0)
            make.centerX.equalTo(self.progressView.firstProgressView)
            make.bottom.equalToSuperview()
        }
        
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(2.0)
            make.centerX.equalTo(self.progressView.secondProgressView)
            make.bottom.equalToSuperview()
        }
        
        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(2.0)
            make.centerX.equalTo(self.progressView.thirdProgressView)
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
