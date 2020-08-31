//
//  UpdateOldStudentLocation.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/18/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


class UpdateStudent {
    
    class func updateStudent(updatedStudent: StudentLocation, completion: @escaping (Bool?, Error?) -> Void ) {
        
        var url = URL(string:"https://onthemap-api.udacity.com/v1/StudentLocation")
        url?.appendPathComponent(updatedStudent.objectId)
        
        var request = URLRequest(url: url!)
        print("The updated student: \(updatedStudent)")
        request.httpMethod = "PUT"
        
        var encoder = JSONEncoder()
        let json = try? encoder.encode(updatedStudent)
        
        guard let newJson = json else {
            print("Could not post these data")
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = newJson
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(nil, error)
                return
            }
            completion(true, nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
