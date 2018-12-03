//
//  NetworkHandler+Token.swift
//  friction
//
//  Created by Tim Wong on 12/1/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkHandler {
    func addToken(parameters: Parameters, success: DeviceTokenHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.addToken(parameters: parameters)).validate().responseData { response in
            switch response.result {
            case .success:
                if let token = response.data?.decodeJson(DeviceToken.self) {
                    success?(token)
                } else {
                    failure?(CommonError.invalidJson)
                }
            case .failure(let error): failure?(error)
            }
        }
    }
}
