////
////  GetAllStudentsLocations.swift
////  theMapApp
////
////  Created by Abdulaziz Asiri on 5/12/20.
////  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
////

import Foundation
import  UIKit
import MapKit


enum StuddentURLs: String {
    case getAllStudent = "https://onthemap-a.udacity.com/v1/StudentLocation?order=-updatedAt&?limit=100"
}

class MakeNetworkCall {

    static var studentRecord: StudentLocationArray?
    
    class func makeStudentsREquests ( completionHandler: @escaping (StudentLocationArray?, Error?) -> Void ) {
        
        print("I called this URL \(StuddentURLs.getAllStudent.rawValue)")
        let request = URLRequest(url: URL(string: StuddentURLs.getAllStudent.rawValue)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
               completionHandler(nil, error)
                return
                
            }
            let decoder = JSONDecoder()
            
            do {
                MakeNetworkCall.studentRecord = try decoder.decode(StudentLocationArray.self, from: data!)
                
                
                
                guard let allStudents = MakeNetworkCall.studentRecord else {
                    return
                }
                completionHandler(allStudents, nil)
                print("SIZE WAS FOUND IS    :\(allStudents.results.count)")
                
            } catch {
                
                completionHandler(nil, error)
                
                
            }
            
        }
        task.resume()
    }
    
    
    
}

