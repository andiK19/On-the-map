//
//  Location.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 22.09.22.
//

import Foundation

struct Location: Codable {
    let createdAt: String
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let updatedAt: String
    
}
