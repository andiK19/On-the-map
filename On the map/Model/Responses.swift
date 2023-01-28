//
//  Responses.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 21.09.22.
//

import Foundation

struct UserLoginResponse: Codable {
    let account: UserAccount
    let session: Session
}

struct UserAccount: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct UserProfileResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct StudentLocationsResponse: Codable {
    let results: [StudentInformation]
}

struct PostLocationResponse: Codable {
    let createdAt: String?
    let objectId: String?
}

struct UpdatedLocationResponse: Codable {
    let updatedAt: String?
}
