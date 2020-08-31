//
//  GetAllStudentRequest.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/12/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation
import MapKit

struct GetAllStudentRequest {
    static var studentRecord: StudentLocationArray?
    static func makeStudentInfoRequest() -> StudentLocationArray?{
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        //         var student: StudentLocationArray?
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                return nil
                
            }
            let decoder = JSONDecoder()
            
            do {
                self.studentRecord = try decoder.decode(StudentLocationArray.self, from: data!)
                
            
                
                
            }
            
                r
            
            catch {
                print("Error Occured: \(error)")
                
            }
            
            return studentRecord
            
        }
        task.resume()
    }
    
}
