//
//  API.swift
//  PinSample
//
//  Created by Ammar AlTahhan on 15/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class API {
    
    private static var accountId: String?
    private static var sessionId: String?
    
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.SESSION) else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode < 400 { //Response is ok
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        self.sessionId = sessionDict["id"] as? String
                        self.accountId = accountDict["key"] as? String
                    } else { //Err in parsing data
                        errString = "Couldn't parse response"
                    }
                } else { //Err in given login credintials
                    errString = "Provided login credintials didn't match our records"
                }
            } else { //Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    static func getPublicUserName(completion: @escaping (String?, String?)->Void) {
        guard let userId = self.accountId, let url = URL(string: "\(APIConstants.PUBLIC_USER)/\(userId)") else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(self.sessionId!, forHTTPHeaderField: "session_id")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var firstName: String?, lastName: String?, nickname: String = ""
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 400 { //Request sent succesfully
                let newData = data?.subdata(in: 5..<data!.count)
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: [.allowFragments]),
                    let dict = json as? [String:Any],
                    let user = dict["user"] as? [String:Any],
                    let guardDict = user["guard"] as? [String:Any] {
                    nickname = user["nickname"] as? String ?? ""
                    firstName = guardDict["first_name"] as? String ?? nickname
                    lastName = user["last_name"] as? String ?? nickname
                }
            }
            
            DispatchQueue.main.async {
                completion(firstName, lastName)
            }
            
        }
        task.resume()
    }
    
    class Parser {
        
        static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsData?)->Void) {
            guard let url = URL(string: "\(APIConstants.STUDENT_LOCATION)?\(APIConstants.ParameterKeys.LIMIT)=\(limit)&\(APIConstants.ParameterKeys.SKIP)=\(skip)&\(APIConstants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.addValue(APIConstants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_APP_ID)
            request.addValue(APIConstants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_API_KEY)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var studentLocations: [StudentLocation] = []
                if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                    if statusCode < 400 { //Response is ok
                        
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                            let dict = json as? [String:Any],
                            let results = dict["results"] as? [Any] {
                            
                            for location in results {
                                let data = try! JSONSerialization.data(withJSONObject: location)
                                let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                                studentLocations.append(studentLocation)
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(LocationsData(studentLocations: studentLocations))
                }
                
            }
            task.resume()
        }
        
        static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
            guard let accountId = accountId, let url = URL(string: "\(APIConstants.STUDENT_LOCATION)") else {
                completion("Invilid url")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.addValue(APIConstants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_APP_ID)
            request.addValue(APIConstants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_API_KEY)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(accountId)\", \"firstName\": \"\(location.firstName ?? "John")\", \"lastName\": \"\(location.lastName ?? "Doe")\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var errString: String?
                print(String(data: data!, encoding: .utf8)!)
                if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                    if statusCode >= 400 { //Response is not ok
                        errString = "Couldn't post your location"
                    }
                } else { //Request failed to sent
                    errString = "Check your internet connection"
                }
                DispatchQueue.main.async {
                    completion(errString)
                }
            }
            task.resume()
        }
        
    }
    
    
    
}
