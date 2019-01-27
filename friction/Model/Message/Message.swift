//
//  Message.swift
//  friction
//
//  Created by Tim Wong on 12/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

class Message: Decodable {
    struct Clap: Decodable {
        enum CodingKeys: String, CodingKey {
            case id, claps
        }
        
        var id: String
        var claps: Int
    }
    
    struct Dislike: Decodable {
        enum CodingKeys: String, CodingKey {
            case id, dislikes
        }
        
        var id: String
        var dislikes: Int
    }
    
    struct Constants {
        struct Limit {
            static let claps = 50
            static let dislikes = 50
        }
    }
    
    var id: String
    
    weak var poll: Poll?
    weak var option: Poll.Option?
    
    var message: String
    var claps: Int
    var dislikes: Int
    
    var name: String
    var imageUrl: String?
    
    var date: Date
    
    var addedClap: Clap?
    var addedDislike: Dislike?
    
    private(set) var isPendingClaps = false
    private(set) var isPendingDislikes = false
    
    enum CodingKeys: String, CodingKey {
        case id, message, claps, dislikes, name
        case pollId = "poll_id"
        case optionId = "option_id"
        case imageUrl = "image_url"
        case date = "inserted_at"
        case addedClap = "added_clap"
        case addedDislike = "added_dislike"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        message = try container.decode(String.self, forKey: .message)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        claps = try container.decode(Int.self, forKey: .claps)
        dislikes = try container.decodeIfPresent(Int.self, forKey: .dislikes) ?? 0
        addedClap = try container.decodeIfPresent(Clap.self, forKey: .addedClap)
        addedDislike = try container.decodeIfPresent(Dislike.self, forKey: .addedDislike)
        let pollId = try container.decode(String.self, forKey: .pollId)
        let optionId = try container.decode(String.self, forKey: .optionId)
        let dateStr = try container.decode(String.self, forKey: .date)
        guard let poll = PollHolder.shared.getPoll(id: pollId), let option = poll.getOption(id: optionId), let date = DateFormatter.iso861.date(from: dateStr) else {
            throw CommonError.invalidJson
        }
        self.poll = poll
        self.option = option
        self.date = date
    }
    
    // MARK: claps
    
    func addClaps(_ claps: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        if let clap = addedClap {
            updateClapsHelper(clap: clap, claps: claps, success: success, failure: failure)
        } else {
            addClapsHelper(claps: claps, success: success, failure: failure)
        }
    }
    
    private func addClapsHelper(claps: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        isPendingClaps = true
        
        NetworkHandler.shared.addClaps(messageId: id, parameters: [CodingKeys.claps.rawValue: claps], success: { clap in
            self.addedClap = clap
            self.claps += claps
            self.isPendingClaps = false
            success?()
        }, failure: { error in
            self.isPendingClaps = false
            failure?(error)
        })
    }
    
    private func updateClapsHelper(clap: Clap, claps: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        isPendingClaps = true
        
        NetworkHandler.shared.updateClaps(messageId: id, clapId: clap.id, parameters: [CodingKeys.claps.rawValue: claps], success: { clap in
            self.addedClap = clap
            self.claps += claps
            self.isPendingClaps = false
            success?()
        }) { error in
            self.isPendingClaps = false
            failure?(error)
        }
    }
    
    // MARK: dislikes
    
    func addDislikes(_ dislikes: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        if let dislike = addedDislike {
            updateDislikesHelper(dislike: dislike, dislikes: dislikes, success: success, failure: failure)
        } else {
            addDislikesHelper(dislikes: dislikes, success: success, failure: failure)
        }
    }
    
    private func addDislikesHelper(dislikes: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        isPendingDislikes = true
        
        NetworkHandler.shared.addDislikes(messageId: id, parameters: [CodingKeys.dislikes.rawValue: dislikes], success: { dislike in
            self.addedDislike = dislike
            self.dislikes += dislikes
            self.isPendingDislikes = false
            success?()
        }, failure: { error in
            self.isPendingDislikes = false
            failure?(error)
        })
    }
    
    private func updateDislikesHelper(dislike: Dislike, dislikes: Int, success: EmptyHandler?, failure: ErrorHandler?) {
        isPendingDislikes = true
        
        NetworkHandler.shared.updateDislikes(messageId: id, dislikeId: dislike.id, parameters: [CodingKeys.dislikes.rawValue: dislikes], success: { dislike in
            self.addedDislike = dislike
            self.dislikes += dislikes
            self.isPendingDislikes = false
            success?()
        }) { error in
            self.isPendingDislikes = false
            failure?(error)
        }
    }
}
