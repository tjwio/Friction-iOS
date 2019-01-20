//
//  FullMessageTableViewCell.swift
//  friction
//
//  Created by Tim Wong on 12/2/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class FullMessageTableViewCell: UITableViewCell, ClapViewDelegate {
    
    var clapCallback: ((_ claps: Int) -> Void)?
    var dislikeCallback: ((_ dislikes: Int) -> Void)?
    
    let avatarView: AvatarView = {
        let imageView = AvatarView(image: .blankAvatarBlack, shadowHidden: true)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let messageView: MessageView = {
        let messageView = MessageView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        return messageView
    }()
    
    let clapView: ClapView = {
        let clapView = ClapView()
        clapView.translatesAutoresizingMaskIntoConstraints = false
        
        return clapView
    }()
    
    let dislikeView: ClapView = {
        let view = ClapView()
        view.icon.text = "👎"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy private var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dislikeView, clapView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8.0
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
        clapView.delegate = self
        dislikeView.delegate = self
        
        contentView.addSubview(avatarView)
        contentView.addSubview(messageView)
        contentView.addSubview(buttonStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(30.0)
        }
        
        messageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.avatarView.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.height.greaterThanOrEqualTo(48.0)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalTo(self.messageView).offset(-6.0)
            make.centerY.equalTo(self.messageView.snp.bottom).offset(6.0)
        }
        
        clapView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(44.0)
        }
        
        dislikeView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(44.0)
        }
        
        super.updateConstraints()
    }
    
    // MARK: delegate
    
    func clapView(_ clapView: ClapView, didClap claps: Int) {
        if clapView === dislikeView {
            dislikeCallback?(claps)
        } else {
            clapCallback?(claps)
        }
    }
}
