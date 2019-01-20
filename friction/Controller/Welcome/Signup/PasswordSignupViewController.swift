//
//  PasswordSignupViewController.swift
//  friction
//
//  Created by Tim Wong on 1/14/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class PasswordSignupViewController: BaseSignupViewController {
    
    var email: String
    var username: String
    
    init(email: String, username: String) {
        self.email = email
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Add a Password"
        iconLabel.text = String.featherIcon(name: .lock)
        descriptionLabel.text = "And then you're good to go.\nHappy Clashing!"
        
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        
        nextButton.setTitle("Complete", for: .normal)
        
        textField.becomeFirstResponder()
        
        imageView.image = .abstract3
    }
    
    override func nextStep(_ sender: LoadingButton?) {
        AuthenticationManager.shared.signup(name: username, email: email, password: textField.text!, success: { user in
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as? AppDelegate)?.loadMainViewController()
            }
        }) { error in
            print("failed to create account with error: \(error)")
            self.nextButton.isLoading = false
            self.showLeftMessage("Failed to create accout. Please try again", type: .error, options: [.height(66.0)])
        }
    }
    
    override func isValidEntry(_ string: String) -> Bool {
        return string.count >= 6
    }
}
