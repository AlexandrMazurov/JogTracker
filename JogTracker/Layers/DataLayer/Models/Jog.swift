//
//  Jog.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

struct GetJogsResponse: Decodable {
    let response: Jogs
}

struct Jogs: Decodable {
    let jogs: [Jog]
}

struct Jog: Decodable {
    let id: Int?
    let userId: String?
    let distance: Float
    let time: Float
    let date: Date
    var speed: Float {
        return distance / (time / 60)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case distance = "distance"
        case time = "time"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        distance = try container.decode(Float.self, forKey: .distance)
        time = try container.decode(Float.self, forKey: .time)
        date = try container.decode(Date.self, forKey: .date)
    }
}
