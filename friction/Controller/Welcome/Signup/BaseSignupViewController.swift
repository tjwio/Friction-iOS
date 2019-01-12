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
        label.font = .featherFont(size: 24.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirItalic(size: 14.0)
        label.textColor = UIColor.Grayscale.darker
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
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
        textField.leftViewMode = .always
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
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var infoIconStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoLabel, iconLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var backButton: UIButton!
    
    private var keyboardConstraint: Constraint?
    
    private var disposables = CompositeDisposable()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        disposables.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(infoIconStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
        view.addSubview(imageView)
        
        backButton = addBackButtonToView(dark: true, top: 56.0)
        
        setupConstraints()
        
        disposables += nextButton.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(1.0)
        }
        
        disposables += nextButton.reactive.controlEvents(UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupConstraints() {
        infoIconStackView.snp.makeConstraints { make in
            make.top.equalTo(self.backButton.snp.bottom).offset(35.0)
            make.leading.equalToSuperview().offset(44.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.infoIconStackView.snp.bottom)
            make.leading.equalToSuperview().offset(44.0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(40.0)
            make.leading.equalToSuperview().offset(44.0)
            make.trailing.equalToSuperview().offset(-44.0)
            make.height.equalTo(44.0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.textField.snp.bottom).offset(12.0)
            make.trailing.equalToSuperview().offset(-44.0)
            make.height.equalTo(44.0)
            make.width.equalTo(150.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.nextButton.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            self.keyboardConstraint = make.bottom.lessThanOrEqualToSuperview().constraint
        }
        
        self.keyboardConstraint?.deactivate()
    }
    
    // MARK: Keyboard Notifications
    
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if self.navigationController?.viewControllers.last == self && self.isViewLoaded && self.view.window != nil {
            if let keyboardHeight = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboardConstraint?.update(offset: -(keyboardHeight.height + 12.0))
                self.keyboardConstraint?.activate()
                self.view.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification?) {
        if self.navigationController?.viewControllers.last == self && self.isViewLoaded && self.view.window != nil {
            self.keyboardConstraint?.deactivate()
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
