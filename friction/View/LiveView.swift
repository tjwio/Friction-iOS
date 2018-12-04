//
//  LiveView.swift
//  friction
//
//  Created by Tim Wong on 11/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class LiveView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 14.0)
        label.text = GlobalStrings.live.localized.uppercased()
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Red.light
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, circleView])
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
        addSubview(stackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.height.width.equalTo(8.0)
        }
        
        super.updateConstraints()
    }
}
