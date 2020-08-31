//
//  GetStudentsCall.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/12/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


struct GetStudents {
    
    static func getStudents(newJson: Data) -> Bool{
          
        //        print("New JSON: \(newJson)")
                var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                request.httpBody = newJson
            

              
                let session = URLSession.shared
                let task = session.dataTask(with: request ){ data, response, error in
                  if error != nil {
                      return
                  }
              
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    
                    
                    print("String is: user\(String(data: newData!, encoding: .utf8)!)")
                    

                    
                    
                }
                task.resume()
        
        return false
    }
}
