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
    case loadUser, getPolls, getAllVotes, getMessages(pollId: String)
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    case uploadImage
    case addVote(parameters: Parameters)
    case addClaps(messageId: String, parameters: Parameters)
    case addDislikes(messageId: String, parameters: Parameters)
    case addToken(parameters: Parameters)
    
    //MARK: PUT
    case updateUser(parameters: Parameters)
    case updateVote(id: String, parameters: Parameters)
    case updateClaps(messageId: String, clapId: String, parameters: Parameters)
    case updateDislikes(messageId: String, dislikeId: String, parameters: Parameters)
    
    //MARK: DELETE
    
    var method: HTTPMethod {
        switch self {
        case .loadUser, .getPolls, .getAllVotes, .getMessages:
            return .get
        case .signup, .login, .uploadImage, .addVote, .addClaps, .addDislikes, .addToken:
            return .post
        case .updateUser, .updateVote, .updateClaps, .updateDislikes:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .loadUser, .updateUser:
            return "/users"
        case .getPolls:
            return "/polls"
        case .getAllVotes:
            return "/votes"
        case .getMessages(let pollId):
            return "/polls/\(pollId)/messages"
        case .signup:
            return "/users/signup"
        case .login:
            return "/users/login"
        case .uploadImage:
            return "/upload/image"
        case .addVote:
            return "/votes"
        case .addClaps(let messageId, _):
            return "/messages/\(messageId)/claps"
        case .addDislikes(let messageId, _):
            return "/messages/\(messageId)/dislikes"
        case .addToken:
            return "/token"
        case .updateVote(let id, _):
            return "/votes/\(id)"
        case .updateClaps(let messageId, let clapId, _):
            return "/messages/\(messageId)/claps/\(clapId)"
        case .updateDislikes(let messageId, let dislikeId, _):
            return "/messages/\(messageId)/dislikes/\(dislikeId)"
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
        case .signup(let parameters), .login(let parameters), .addVote(let parameters), .addClaps(_, let parameters), .addDislikes(_, let parameters), .addToken(let parameters), .updateUser(let parameters), .updateVote(_, let parameters), .updateClaps(_, _, let parameters), .updateDislikes(_, _, let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        print("\(urlRequest.cURL)")
        
        return urlRequest
    }
}
