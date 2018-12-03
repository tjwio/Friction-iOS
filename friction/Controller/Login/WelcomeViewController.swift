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
        label.text = "Friction."
        label.textColor = .white
        label.font = UIFont.avenirBold(size: 60.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .launchImageBg)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
        button.setTitle("GET STARTED", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.layer.cornerRadius = 27.0
        button.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.35)
        }
        
        button.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.5)
        }
        
        return button
    }()
    
    let loginButton: UIButton = {
        let loginAttString = NSMutableAttributedString(string: "Log in");
        loginAttString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, loginAttString.length));
        loginAttString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, loginAttString.length));
        
        let button = UIButton(type: .custom)
        button.setAttributedTitle(loginAttString, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        createAccountButton.addTarget(self, action: #selector(self.createAccount(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.login(_:)), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.addSubview(ciaoLabel)
        view.addSubview(createAccountButton)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        ciaoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(105.0)
            make.centerX.equalTo(self.view)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(48.0)
            make.trailing.equalTo(self.view).offset(-48.0)
            make.bottom.equalTo(self.loginButton.snp.top).offset(-20.0)
            make.centerX.equalTo(self.view)
            make.height.equalTo(54.0)
        }
    }
    
    //MARK: create account
    @objc private func createAccount(_ sender: UIButton?) {
        let viewController = SignupViewController()
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
