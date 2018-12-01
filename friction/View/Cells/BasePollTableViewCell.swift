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
    func didSelect(item: (value: String, count: Int, selected: Bool), itemIndex: Int, cellIndex: Int)
}

class BasePollTableViewCell: UITableViewCell {
    
    private struct Constants {
        struct Button {
            static let height = 44.0
            static let width = 125.0
        }
    }
    
    var delegate: PollSelectionDelegate?
    
    var items = [(value: String, count: Int, selected: Bool)]() {
        didSet {
            reloadButtons()
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
    
    let scrollView: UIScrollView = {
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
        contentView.addSubview(scrollView)
        contentView.addSubview(avatarStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.greaterThanOrEqualToSuperview().offset(-48.0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.height.equalTo(Constants.Button.height)
        }
        
        avatarStackView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        super.updateConstraints()
    }
    
    // MARK: button scroll view
    
    private func reloadButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        guard !items.isEmpty else { return }
        
        var item = items.first!
        var prevButton = PercentageButton(value: item.value, count: item.count, color: .pollColor(index: 0), selected: item.selected)
        prevButton.tag = 0
        buttons.append(prevButton)
        scrollView.addSubview(prevButton)
        
        prevButton.addTarget(self, action: #selector(self.didSelectButton(_:)), for: .touchUpInside)
        
        prevButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(Constants.Button.width)
            make.height.equalTo(Constants.Button.height)
        }
        
        for index in 1..<items.endIndex {
            item = items[index]
            let nextButton = PercentageButton(value: item.value, count: item.count, color: .pollColor(index: index % 3), selected: item.selected)
            nextButton.tag = index
            nextButton.addTarget(self, action: #selector(self.didSelectButton(_:)), for: .touchUpInside)
            buttons.append(nextButton)
            scrollView.addSubview(nextButton)
            
            nextButton.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(prevButton.snp.trailing).offset(12.0)
                make.width.equalTo(Constants.Button.width)
                make.height.equalTo(Constants.Button.height)
            }
            
            prevButton = nextButton
        }
        
        prevButton.snp.makeConstraints { make in
            make.trailing.greaterThanOrEqualToSuperview()
        }
        
        setNeedsLayout()
    }
    
    // MARK: button helper
    
    @objc private func didSelectButton(_ sender: UIButton) {
        delegate?.didSelect(item: items[sender.tag], itemIndex: sender.tag, cellIndex: index)
    }
}
