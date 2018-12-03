//
//  NetworkHandler+Image.swift
//  friction
//
//  Created by Tim Wong on 12/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension NetworkHandler {
    private struct Constants {
        static let name = "file"
        static let mimeType = "image/jpeg"
    }
    
    public func uploadImage(_ image: Data, filename: String, success: JSONHandler?, failure: ErrorHandler?) {
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: Constants.name, fileName: filename, mimeType: Constants.mimeType)
        }, with: URLRouter.uploadImage) { result in
            switch result {
            case .success(let upload, _, _):
                upload.validate().responseJSON(completionHandler: { response in
                    success?(response.result.value as? JSON ?? JSON())
                })
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
