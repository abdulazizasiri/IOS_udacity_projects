//
//  PostStudent.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/19/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


class PostStudent {
    
    class func postDtudent(newUser: StudentLocation, completion: @escaping (Bool?,  Error?)->Void) {
        let newLocal: StudentLocation = newUser
          let encoder = JSONEncoder()
          
          let json = try? encoder.encode(newLocal)
          
          guard let newJson = json else {
              print("Could not post these data")
              return
          }
          
          var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
          request.httpMethod = "POST"
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
