//
//  BaseSignupViewController.swift
//  friction
//
//  Created by Tim Wong on 1/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class BaseSignupViewController: UIViewController {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 20.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .featherFont(size: 20.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirItalic(size: 14.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.Grayscale.backgroundLight
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.font = .avenirRegular(size: 14.0)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.Grayscale.light.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 44.0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Pink.normal
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    
    private lazy var infoIconStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoLabel, iconLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(infoIconStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
        
        setupConstraints()
        
        _ = addBackButtonToView(dark: true)
    }
    
    private func setupConstraints() {
        
    }
}
