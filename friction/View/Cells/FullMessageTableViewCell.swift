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
        
        contentView.addSubview(avatarView)
        contentView.addSubview(messageView)
        contentView.addSubview(clapView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(30.0)
        }
        
        messageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(self.avatarView.snp.trailing).offset(10.0)
            make.height.greaterThanOrEqualTo(48.0)
        }
        
        clapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.messageView.snp.trailing).offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
            make.height.equalTo(48.0)
            make.width.equalTo(54.0)
        }
        
        super.updateConstraints()
    }
    
    // MARK: delegate
    
    func clapView(_ clapView: ClapView, didClap claps: Int) {
        clapCallback?(claps)
    }
}
