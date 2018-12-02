//
//  User.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

public class User: NSObject, Decodable {
    var id: String
    var email: String
    var name: String
    var imageUrl: String?
    let image = MutableProperty<UIImage?>(nil)
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case imageUrl = "image_url"
    }
    
    // MARK: image
    
    func loadImage(success: ImageHandler?, failure: ErrorHandler?) {
        if let image = image.value {
            success?(image)
            return
        }
        
        if let imageUrl = self.imageUrl {
            SDWebImageManager.shared().loadImage(with: URL(string: imageUrl), options: .retryFailed, progress: nil) { (image, _, error, _, _, _) in
                if let image = image {
                    self.image.value = image
                    success?(image)
                } else {
                    failure?(error ?? CommonError.nilOrEmpty)
                }
            }
        } else {
            failure?(CommonError.nilOrEmpty)
        }
    }
    
    // MARK: update
    
    func updateUser(name: String, email: String, success: EmptyHandler?, failure: ErrorHandler?) {
        let params = [
            CodingKeys.name.rawValue: name,
            CodingKeys.email.rawValue: email
        ]
        
        NetworkHandler.shared.updateUser(parameters: params, success: {
            self.name = name
            self.email = email
            success?()
        }, failure: failure)
    }
}
