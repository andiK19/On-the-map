//
//  StudentData.swift
//  On_the_Map_AK_V1.3
//
//  Created by Andreas Kremling on 22.09.22.
//

import Foundation
import MapKit


class StudentsData: NSObject {
    var students = [StudentInformation]()
    
    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }
}


struct StudentInformation: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String
    }
    
//method to create annotation for location
    func createMKPointAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        return annotation
    }
}
