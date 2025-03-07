//
//  BAProfileDetailValueTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 9/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class ProfileDetailValueTableViewCell: UITableViewCell {
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.Grayscale.dark
        textField.font = UIFont.avenirRegular(size: 14.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirDemi(size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let accountHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexColor: 0xD8DBE0)
        view.layer.cornerRadius = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.featherFont(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var defaultIconColor = UIColor(hexColor: 0xD8DBE0) {
        didSet {
            updateIconColor(isHidden: textField.text?.isEmpty ?? true)
        }
    }
    
    var textIconColor: UIColor? {
        didSet {
            updateIconColor(isHidden: textField.text?.isEmpty ?? true)
        }
    }
    
    private var disposables = CompositeDisposable()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        backgroundColor = .white
        
        accountHolderView.addSubview(iconLabel)
        contentView.addSubview(textField)
        contentView.addSubview(detailLabel)
        contentView.addSubview(accountHolderView)
        
        setNeedsUpdateConstraints()
        
        disposables += textField.reactive.continuousTextValues.map { return $0.isEmpty }.observeValues { [weak self] hidden in
            self?.updateIconColor(isHidden: hidden)
        }
    }
    
    override func updateConstraints() {
        textField.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.centerX).offset(-30.0)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.textField.snp.leading).offset(-10.0)
            make.centerY.equalToSuperview()
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalTo(self.accountHolderView)
        }
        
        accountHolderView.snp.makeConstraints { make in
            make.trailing.equalTo(self.detailLabel)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(32.0)
        }
        
        super.updateConstraints()
    }
    
    // MARK: helper ui
    
    private func updateIconColor(isHidden: Bool) {
        guard let iconColor = textIconColor else { accountHolderView.backgroundColor = defaultIconColor; return }
        
        accountHolderView.backgroundColor = isHidden ? defaultIconColor : iconColor
    }
}
