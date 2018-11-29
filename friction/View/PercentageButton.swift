//
//  PercentageButton.swift
//  friction
//
//  Created by Tim Wong on 11/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class PercentageButton: UIButton {
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 11.0)
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var isChosen = false
    private var selectedColor: UIColor?
    
    private var disposables = CompositeDisposable()
    
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
        
        isChosen = selected
        selectedColor = color
        
        if selected {
            backgroundColor = color
        } else {
            backgroundColor = .white
        }
        
        disposables += reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue)).observeValues { [weak self] _ in
            self?.backgroundColor = self?.isChosen ?? false ? self?.selectedColor ?? .white : .white
        }
        
        disposables += reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { [weak self] _ in
            self?.backgroundColor = self?.selectedColor ?? .white
        }
    }
    
    deinit {
        disposables.dispose()
    }
    
    private func commonInit() {
        layer.cornerRadius = 4.0
        
        setTitleColor(UIColor.Grayscale.dark, for: .normal)
        titleLabel?.font = .avenirDemi(size: 14.0)
        
        addSubview(percentLabel)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        percentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2.0)
            make.trailing.equalToSuperview().offset(-2.0)
        }
        
        super.updateConstraints()
    }
}
