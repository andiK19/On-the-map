//
//  SupportingClientMethods.swift
//  On_the_Map_AK_V1.3
//
//  Created by Andreas Kremling on 21.09.22.
//

import Foundation

class SupportingClientMethods {
    
//taskForGetRequest-Method for different kinds of API
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, udacityAPI: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
//check if it´s an Udacity-API
                if udacityAPI == true {
                    
                    let range = 5..<data.count
//don´t use the first 5 characters
                    let newData = data.subdata(in: range)
//decode
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
//for other APIs...
                else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
        }
    }
        task.resume()
    
}

//taskForPostRequest-Method for different kinds of API
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, udacityAPI: Bool, responseType: ResponseType.Type, body: String, httpRequestType: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        if httpRequestType == "POST" {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
//check if it´s an Udacity-API and add appropriate values to request
        if udacityAPI == true {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
//check again if it´s an Udacity-API and skip first 5 characters if necessary
                if udacityAPI == true {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
//decode...
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
                else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
