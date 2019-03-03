//
//  LoginViewController.swift
//  friction
//
//  Created by Tim Wong on 1/19/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import UserNotifications

class LoginViewController: BaseSignupViewController {

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.Grayscale.backgroundLight
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.font = .avenirRegular(size: 14.0)
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.layer.borderColor = UIColor.Grayscale.light.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 44.0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    override var enabledTextFields: [UITextField] {
        return [textField, passwordTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Welcome back"
        iconLabel.text = String.featherIcon(name: .compass)
        descriptionLabel.text = "Log in using your email and password below"
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        
        nextButton.setTitle("Login", for: .normal)
        
        textField.becomeFirstResponder()
        passwordTextField.delegate = self
        
        imageView.image = .abstract4
        
        textFieldStackView.addArrangedSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44.0)
        }
    }
    
    override func nextStep(_ sender: LoadingButton?) {
        sender?.isLoading = true
        AuthenticationManager.shared.login(email: self.textField.text!, password: self.passwordTextField.text!, success: { user in
            UNUserNotificationCenter.current().requestAuthorizationStatus()
            
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as? AppDelegate)?.loadMainViewController()
            }
        }) { error in
            print("failed to login with error: \(error)")
            self.nextButton.isLoading = false
            self.showLeftMessage("Failed to login. Please try again", type: .error, options: [.height(66.0)])
        }
    }
    
    override func isValidEntry(_ string: String) -> Bool {
        guard super.isValidEntry(string) else { return false }
        
        if string == textField.text {
            return CommonUtility.isValidEmail(string)
        } else if string == passwordTextField.text {
            return string.count >= 6
        }
        
        return false
    }
}
