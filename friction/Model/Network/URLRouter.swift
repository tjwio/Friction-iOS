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
    case loadUser, getPolls, getAllVotes
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    case uploadImage
    case addVote(parameters: Parameters)
    case addToken(parameters: Parameters)
    
    //MARK: PUT
    case updateUser(parameters: Parameters)
    case updateVote(id: String, parameters: Parameters)
    
    //MARK: DELETE
    
    var method: HTTPMethod {
        switch self {
        case .loadUser, .getPolls, .getAllVotes:
            return .get
        case .signup, .login, .uploadImage, .addVote, .addToken:
            return .post
        case .updateUser, .updateVote:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .loadUser, .updateUser:
            return "/users"
        case .signup:
            return "/users/signup"
        case .login:
            return "/users/login"
        case .uploadImage:
            return "/upload/image"
        case .getPolls:
            return "/polls"
        case .getAllVotes:
            return "/votes"
        case .addVote:
            return "/votes"
        case .addToken:
            return "/token"
        case .updateVote(let id, _):
            return "/votes/\(id)"
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
        case .signup(let parameters), .login(let parameters), .addVote(let parameters), .addToken(let parameters), .updateUser(let parameters), .updateVote(_, let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        print("\(urlRequest.cURL)")
        
        return urlRequest
    }
}
