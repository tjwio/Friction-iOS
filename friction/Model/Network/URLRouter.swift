//
//  URLRouter.swift
//  friction
//
//  Created by Tim Wong on 11/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

enum URLRouter: URLRequestConvertible {
    //MARK: GET
    case loadUser
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    case uploadImage
    
    //MARK: PUT
    case updateUser(parameters: Parameters)
    
    //MARK: DELETE
    
    var method: HTTPMethod {
        switch self {
        case .loadUser:
            return .get
        case .signup, .login, .uploadImage:
            return .post
        case .updateUser:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .loadUser, .updateUser:
            return "/users/me"
        case .signup:
            return "/signup"
        case .login:
            return "/login"
        case .uploadImage:
            return "/upload/image"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try AppManager.shared.environment.apiUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let authHeader = AuthenticationManager.shared.authToken {
            urlRequest.setValue("Bearer \(authHeader)", forHTTPHeaderField: "Authorization");
        }
        
        switch self {
        case .signup(let parameters), .login(let parameters), .updateUser(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        print("\(urlRequest.cURL)")
        
        return urlRequest
    }
}
