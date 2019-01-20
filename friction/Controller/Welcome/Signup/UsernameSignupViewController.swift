//
//  UsernameSignupViewController.swift
//  friction
//
//  Created by Tim Wong on 1/12/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class UsernameSignupViewController: BaseSignupViewController {
    
    var email: String
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Create your Username"
        iconLabel.text = String.featherIcon(name: .mail)
        descriptionLabel.text = "This is how your profile will\nappear to others"
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.keyboardType = .default
        textField.placeholder = "Username"
        
        nextButton.addTarget(self, action: #selector(self.nextStep(_:)), for: .touchUpInside)
        nextButton.setTitle("Next Step", for: .normal)
        
        textField.becomeFirstResponder()
        
        imageView.image = .abstract2
    }
    
    override func nextStep(_ sender: LoadingButton?) {
        sender?.isLoading = false
        let viewController = PasswordSignupViewController(email: email, username: textField.text!)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
}
