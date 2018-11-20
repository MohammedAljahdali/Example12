//
//  StudentLocation.swift
//  PinSample
//
//  Created by Ammar AlTahhan on 15/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation {
    var createdAt: String
    var firstName: String?
    var lastName: String?
    var latitude: Float
    var longitude: Float
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
}


extension StudentLocation: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        latitude = try values.decodeIfPresent(Float.self, forKey: .latitude) ?? 0
        longitude = try values.decodeIfPresent(Float.self, forKey: .longitude) ?? 0
        mapString = try values.decodeIfPresent(String.self, forKey: .mapString) ?? ""
        mediaURL = try values.decodeIfPresent(String.self, forKey: .mediaURL) ?? ""
        objectId = try values.decodeIfPresent(String.self, forKey: .objectId) ?? ""
        uniqueKey = try values.decodeIfPresent(String.self, forKey: .uniqueKey) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? "" 
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(mapString, forKey: .mapString)
        try container.encode(mediaURL, forKey: .mediaURL)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(uniqueKey, forKey: .uniqueKey)
        try container.encode(updatedAt, forKey: .updatedAt)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}

enum SLParam: String {
    case createdAt
    case firstName
    case lastName
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectId
    case uniqueKey
    case updatedAt
}
