//
//  FRPollTableViewCell.swift
//  friction
//
//  Created by Tim Wong on 11/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class FRBasePollTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirBold(size: 22.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let buttonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .frictionIconAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 12.0)
        label.text = "friction team"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 10.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 10.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateVoteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, voteLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var userNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, dateVoteStackView])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var avatarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, userNameStackView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(buttonScrollView)
        contentView.addSubview(avatarStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.greaterThanOrEqualToSuperview().offset(-48.0)
        }
        
        buttonScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        avatarStackView.snp.makeConstraints { make in
            make.top.equalTo(self.buttonScrollView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        super.updateConstraints()
    }
}
