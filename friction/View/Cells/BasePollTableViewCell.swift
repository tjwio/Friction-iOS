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

class BasePollTableViewCell: UITableViewCell {
    
    private struct Constants {
        struct Button {
            static let height = 44.0
            static let width = 125.0
        }
    }
    
    var delegate: PollSelectionDelegate?
    
    var items = [(value: String, percent: Double, selected: Bool)]() {
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
    
    let firstProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let secondProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let thirdProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .pollColor(index: 2)
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(scrollView)
        contentView.addSubview(avatarStackView)
        contentView.addSubview(firstProgressView)
        contentView.addSubview(secondProgressView)
        contentView.addSubview(thirdProgressView)
        
        clipsToBounds = true
        
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
        var prevButton = PercentageButton(value: item.value, count: Int(item.percent * 100.0), color: .pollColor(index: 0), selected: item.selected)
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
            let nextButton = PercentageButton(value: item.value, count: Int(item.percent * 100.0), color: .pollColor(index: index % 3), selected: item.selected)
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
        
        reloadProgressViews()
        
        setNeedsLayout()
    }
    
    private func reloadProgressViews() {
        let firstWidth = items.isEmpty ? 0.0 : items[0].percent
        let secondWidth = items.count >= 2 ? items[1].percent : 0.0
        let thirdWidth = items.count >= 3 ? items[2].percent : 0.0
        
        firstProgressView.snp.remakeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalToSuperview().multipliedBy(firstWidth)
        }
        
        secondProgressView.snp.remakeConstraints { make in
            make.leading.equalTo(self.firstProgressView.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalToSuperview().multipliedBy(secondWidth)
        }
        
        thirdProgressView.snp.remakeConstraints { make in
            make.leading.equalTo(self.secondProgressView.snp.trailing)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalToSuperview().multipliedBy(thirdWidth)
        }
    }
    
    // MARK: button helper
    
    @objc private func didSelectButton(_ sender: PercentageButton) {
        if items[sender.tag].selected {
            sender.isLoading = false
        } else {
            delegate?.didSelect(item: items[sender.tag], itemIndex: sender.tag, cellIndex: index)
        }
    }
}
