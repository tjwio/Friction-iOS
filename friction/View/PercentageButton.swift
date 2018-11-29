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
            guard let strongSelf = self else { return }
            
            if strongSelf.isChosen {
                strongSelf.backgroundColor = strongSelf.selectedColor ?? .white
                strongSelf.percentLabel.textColor = .white
            } else {
                strongSelf.backgroundColor = .white
                strongSelf.percentLabel.textColor = UIColor.Grayscale.dark
            }
        }
        
        disposables += reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.backgroundColor = strongSelf.selectedColor ?? .white
            strongSelf.percentLabel.textColor = .white
        }
    }
    
    deinit {
        disposables.dispose()
    }
    
    private func commonInit() {
        layer.cornerRadius = 4.0
        
        let textColor = isChosen ? .white : UIColor.Grayscale.dark
        
        setTitleColor(textColor, for: .normal)
        setTitleColor(.white, for: .highlighted)
        titleLabel?.font = .avenirDemi(size: 14.0)
        
        percentLabel.textColor = textColor
        
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
