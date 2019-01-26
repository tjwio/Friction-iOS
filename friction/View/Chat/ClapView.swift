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
    
    var maxClaps = 0
    
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
        label.font = .systemFont(ofSize: 12.0)
        label.text = "👏"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 9.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, icon])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
            self.label.text = "\(claps+added)"
        }
        
        backgroundColor = .white
        
        layer.cornerRadius = 12.0
        
        addSubview(stackView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0))
        }
        
        super.updateConstraints()
    }
    
    // MARK: long press gesture recognizer
    
    @objc private func longHoldPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began && addedClaps.value < maxClaps {
            addedClaps.value += 1
            
            hapticGenerator.impactOccurred()
            audioPlayer?.play()
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] _ in
                if self.addedClaps.value < self.maxClaps {
                    self.addedClaps.value += 1
                }
                self.hapticGenerator.impactOccurred()
                self.audioPlayer?.play()
            })
            
            layer.borderWidth = 2.0
            label.textColor = UIColor.Grayscale.darker
            
            UIView.animate(withDuration: 0.125) {
                self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }
        } else if sender.state == .ended {
            delegate?.clapView(self, didClap: addedClaps.value)
            timer?.invalidate()
            
            claps.value += addedClaps.value
            maxClaps -= addedClaps.value
            addedClaps.value = 0
            
            layer.borderWidth = 1.0
            label.textColor = UIColor.Grayscale.dark
            
            UIView.animate(withDuration: 0.125) {
                self.transform = .identity
            }
        }
    }
}
