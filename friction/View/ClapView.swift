//
//  ClapView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class ClapView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView(image: .clap)
        imageView.tintImage(color: UIColor.Grayscale.dark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let label: UILabel = {
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
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.Grayscale.light.cgColor
        
        addSubview(imageView)
        addSubview(label)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4.0)
            make.centerX.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
