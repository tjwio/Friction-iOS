//
//  PollTableViewCell.swift
//  friction
//
//  Created by Tim Wong on 11/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

protocol PollSelectionDelegate: class {
    func didSelect(item: (value: String, percent: Double, selected: Bool), itemIndex: Int, cellIndex: Int)
}

class BasePollTableViewCell: UITableViewCell, ButtonScrollViewDelegate {
    
    weak var delegate: PollSelectionDelegate?
    
    var items = [(value: String, percent: Double, selected: Bool)]() {
        didSet {
            scrollView.items = items
            progressHolderView.percents = items.map { return $0.percent }
        }
    }
    
    var buttons = [PercentageButton]()
    
    var index = 0
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirBold(size: 24.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scrollView: ButtonScrollView = {
        let scrollView = ButtonScrollView()
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
        label.font = .avenirDemi(size: 14.0)
        label.text = "friction team"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 12.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirMedium(size: 12.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let doubleSlashLabel: UILabel = {
        let label = UILabel()
        label.text = "//"
        label.font = .avenirLight(size: 12.0)
        label.textColor = UIColor.Grayscale.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateVoteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, doubleSlashLabel, voteLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4.0
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
        stackView.spacing = 6.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var progressHolderView: ProgressView = {
        let view = ProgressView(labelsHidden: true)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        scrollView.selectionDelegate = self
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(avatarStackView)
        contentView.addSubview(progressHolderView)
        
        clipsToBounds = true
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-56.0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.height.equalTo(ButtonScrollView.Constants.Button.height)
        }
        
        avatarStackView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        progressHolderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(4.0)
        }
        
        super.updateConstraints()
    }
    
    // MARK: button scroll view
    
    func buttonScrollView(_ scrollView: ButtonScrollView, didSelect item: (value: String, percent: Double, selected: Bool), at index: Int) {
        delegate?.didSelect(item: item, itemIndex: index, cellIndex: self.index)
    }
}
