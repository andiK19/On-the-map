//
//  Client.swift
//  On_the_Map_AK_V1.3
//
//  Created by Andreas Kremling on 21.09.22.
//

import Foundation
import UIKit

class Client {

//Authentication-Struct
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }

enum Endpoints {
    
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case signUp
    case login
    case getUserProfile
    case getLocations
    case addLocation
    case updateLocation
    
    var stringValue: String {
        switch self {
        case .signUp:
            return "https://auth.udacity.com/sign-up"
        case .login:
            return Endpoints.base + "/session"
        case .getUserProfile:
            return Endpoints.base + "/users/" + Auth.key
        case .getLocations:
            return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
        case .addLocation:
            return Endpoints.base + "/StudentLocation"
        case .updateLocation:
            return Endpoints.base + "/StudentLocation/" + Auth.objectId
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
    
//Method to login using inserted user information
    class func login(mail: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//create body for request
        
        let body = "{\"udacity\": {\"username\": \"\(mail)\", \"password\": \"\(password)\"}}"
        SupportingClientMethods.taskForPOSTRequest(url: Endpoints.login.url, udacityAPI: true, responseType: UserLoginResponse.self, body: body, httpRequestType: "POST") { (response, error) in
            if let response = response {
//Save sessionId and key in Auth-Struct
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
//load user profile
                getUserProfile(completion: { (success, error) in
                    if success {
                    }
                })
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
//Method to load user profile
    class func getUserProfile(completion: @escaping(Bool, Error?) -> Void) {
        SupportingClientMethods.taskForGETRequest(url: Endpoints.getUserProfile.url, udacityAPI: true, responseType: UserProfileResponse.self) { (response, error) in
            if let response = response {
//Save user information in Auth-Struct
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
//Method to get Student locations
    class func loadStudentLocations(completionhandler: @escaping (Bool, Error?) -> Void) {
        SupportingClientMethods.taskForGETRequest(url: Endpoints.getLocations.url, udacityAPI: false, responseType: StudentLocationsResponse.self) { data, error in
            guard let data = data else {
                completionhandler(false, error)
                return
            }
//Save student locations in array
            StudentsData.sharedInstance().students = data.results
            completionhandler(true, nil)
        }
    }
    
//Method to logout
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        deleteUserData()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error logging out.")
                return
            }
//Skip the first 5 characters
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
//Delete sessionId in Auth-Struct
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        //create body for taskForPOSTRequest
                let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
                SupportingClientMethods.taskForPOSTRequest(url: Endpoints.addLocation.url, udacityAPI: false, responseType: PostLocationResponse.self, body: body, httpRequestType: "POST") { (response, error) in
                    if let error = error {
                        completion(false, error)
                    }
                    if let response = response, response.createdAt != nil {
                        Auth.objectId = response.objectId ?? ""
                        completion(true, nil)
                    }
                    completion(false, error)
                }
    }
    
//Method to refresh student location after confirmation
    class func refreshStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
//create body for taskForPOSTRequest
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        SupportingClientMethods.taskForPOSTRequest(url: Endpoints.updateLocation.url, udacityAPI: false, responseType: UpdatedLocationResponse.self, body: body, httpRequestType: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
//method to delete user data
        class func deleteUserData() {
            Auth.sessionId = ""
            Auth.objectId = ""
            Auth.key = ""
        }

}
