//
//  ClapView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

protocol ClapViewDelegate: class {
    func clapView(_ clapView: ClapView, didClap claps: Int)
}

class ClapView: UIView {
    
    var delegate: ClapViewDelegate?
    
    let claps = MutableProperty<Int>(0)
    let addedClaps = MutableProperty<Int>(0)
    
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
    
    private var timer: Timer?
    
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
    
    deinit {
        disposables.dispose()
    }
    
    private func commonInit() {
        let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longHoldPressGestureRecognized(_:)))
        holdGestureRecognizer.minimumPressDuration = 0.0
        addGestureRecognizer(holdGestureRecognizer)
        
        disposables += SignalProducer.combineLatest(claps.producer, addedClaps.producer).startWithValues { [weak self] claps, added in
            self?.label.text = "\(claps+added) claps"
        }
        
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
    
    // MARK: long press gesture recognizer
    
    @objc private func longHoldPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            addedClaps.value += 1
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                self?.addedClaps.value += 1
            })
            
            layer.borderColor = UIColor.Grayscale.darker.cgColor
            imageView.tintImage(color: UIColor.Grayscale.darker)
            label.textColor = UIColor.Grayscale.darker
            
            UIView.animate(withDuration: 0.125) {
                self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }
        } else if sender.state == .ended {
            delegate?.clapView(self, didClap: addedClaps.value)
            timer?.invalidate()
            
            claps.value += addedClaps.value
            addedClaps.value = 0
            
            layer.borderColor = UIColor.Grayscale.light.cgColor
            imageView.tintImage(color: UIColor.Grayscale.dark)
            label.textColor = UIColor.Grayscale.dark
            
            UIView.animate(withDuration: 0.125) {
                self.transform = .identity
            }
        }
    }
}
