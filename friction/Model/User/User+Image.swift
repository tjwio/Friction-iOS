//
//  User+Image.swift
//  friction
//
//  Created by Tim Wong on 12/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import UIKit

extension User {
    var randomImageFileName: String {
        let randomNum = Int(arc4random_uniform(10000))
        
        return "\(name.replacingOccurrences(of: " ", with: "_"))_\(randomNum).jpeg"
    }
    
    func updateImage(_ image: UIImage, success: EmptyHandler?, failure: ErrorHandler?) {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            failure?(CommonError.imageData)
            return
        }
        
        NetworkHandler.shared.uploadImage(data, filename: randomImageFileName, success: { _ in
            self.image.value = image
            success?()
        }) { error in
            print("failed to upload image with error: \(error)")
            failure?(error)
        }
    }
}
