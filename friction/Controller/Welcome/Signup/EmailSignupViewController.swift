//
//  EmailSignupViewController.swift
//  friction
//
//  Created by Tim Wong on 1/10/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class EmailSignupViewController: BaseSignupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Enter your E-mail"
        iconLabel.text = String.featherIcon(name: .mail)
        descriptionLabel.text = "to get started"
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        
        nextButton.addTarget(self, action: #selector(self.nextStep(_:)), for: .touchUpInside)
        nextButton.setTitle("Next Step", for: .normal)
        
        textField.becomeFirstResponder()
        
        imageView.image = .abstract1
    }
    
    @objc private func nextStep(_ sender: Any?) {
        let viewController = UsernameSignupViewController(email: textField.text!)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func isValidEntry(_ string: String) -> Bool {
        return super.isValidEntry(string) && CommonUtility.isValidEmail(string)
    }
}
