//
//  ClapView.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveCocoa
import ReactiveSwift

protocol ClapViewDelegate: class {
    func clapView(_ clapView: ClapView, didClap claps: Int)
}

class ClapView: UIView {
    
    private struct Constants {
        struct Sound {
            static let filename = "clap"
            static let caf = "caf"
        }
    }
    
    weak var delegate: ClapViewDelegate?
    
    let claps = MutableProperty<Int>(0)
    let addedClaps = MutableProperty<Int>(0)
    
    var detailString = GlobalStrings.claps.localized.lowercased() {
        didSet {
            updateLabelText(claps: claps.value + addedClaps.value)
        }
    }
    
    let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var audioPlayer: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: Constants.Sound.filename, withExtension: Constants.Sound.caf) else { return nil }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
            
            return player
        } catch let error {
            print("failed to get audio player with error: \(error)")
            return nil
        }
    }()
    
    let icon: UILabel = {
        let label  = UILabel()
        label.text = "👏"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        
        disposables += SignalProducer.combineLatest(claps.producer, addedClaps.producer).startWithValues { [unowned self] claps, added in
            self.updateLabelText(claps: claps+added)
        }
        
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.Grayscale.light.cgColor
        
        addSubview(icon)
        addSubview(label)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        icon.snp.makeConstraints { make in
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
            hapticGenerator.impactOccurred()
            audioPlayer?.play()
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                self?.addedClaps.value += 1
                self?.hapticGenerator.impactOccurred()
                self?.audioPlayer?.play()
            })
            
            layer.borderColor = UIColor.Grayscale.darker.cgColor
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
            label.textColor = UIColor.Grayscale.dark
            
            UIView.animate(withDuration: 0.125) {
                self.transform = .identity
            }
        }
    }
    
    // MARK: helper
    
    private func updateLabelText(claps: Int) {
        label.text = "\(claps) \(detailString)"
    }
}
