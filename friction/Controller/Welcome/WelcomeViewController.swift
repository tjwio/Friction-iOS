//
//  WelcomeViewController.swift
//  friction
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class WelcomeViewController: UIViewController {
    
    let ciaoLabel: UILabel = {
        let label = UILabel()
        label.text = "friction"
        label.textColor = .black
        label.font = .cocogooseRegular(size: 32.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 14.0)
        label.text = "Heated Debates on Demand."
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let batteryImageView = UIImageView(image: .frictionIconAvatar)
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .launchImageBg)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Pink.normal
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    
    let loginButton: UIButton = {
        let loginAttString = NSMutableAttributedString(string: "Log In");
        loginAttString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, loginAttString.length));
        loginAttString.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, loginAttString.length));
        
        let button = UIButton(type: .custom)
        button.setAttributedTitle(loginAttString, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return button
    }()
    
    private lazy var labelImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ciaoLabel, batteryImageView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var disposables = CompositeDisposable()
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        createAccountButton.addTarget(self, action: #selector(self.createAccount(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.login(_:)), for: .touchUpInside)
        
        disposables += createAccountButton.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(1.0)
        }
        
        disposables += createAccountButton.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
        }
        
        view.addSubview(backgroundImageView)
        view.addSubview(labelImageStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(createAccountButton)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.53)
        }
        
        labelImageStackView.snp.makeConstraints { make in
            make.top.equalTo(self.backgroundImageView.snp.bottom).offset(30.0)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.labelImageStackView.snp.bottom).offset(4.0)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.loginButton.snp.top).offset(-20.0)
            make.centerX.equalTo(self.view)
            make.height.equalTo(44.0)
            make.width.equalTo(200.0)
        }
    }
    
    //MARK: create account
    @objc private func createAccount(_ sender: UIButton?) {
        let viewController = EmailSignupViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: login
    @objc private func login(_ sender: UIButton?) {
        let viewController = LoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
