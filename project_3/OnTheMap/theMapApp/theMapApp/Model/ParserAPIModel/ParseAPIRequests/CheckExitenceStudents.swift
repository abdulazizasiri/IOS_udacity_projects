//
//  CheckExitenceStudents.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/18/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation
//
//  PutExistedStudentsInfo.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/17/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation
import UIKit
enum UpdateStudentsComponents: String{
    case urlUpdate =  "https://onthemap-api.udacity.com/v1/StudentLocation"

}

class StudentsExistnceChecker {
    
    
    class func udateStudentInfo(completionHandler: @escaping (StudentLocationArray?, Error? ) -> Void ) {
        
        
        var myUrl = URLComponents(string: UpdateStudentsComponents.urlUpdate.rawValue)
        
        var querItem = [URLQueryItem(name: "uniqueKey", value: StudentCredentials.myUniqueId)]
        
        myUrl!.queryItems = querItem
        
        
        guard let newUrl = myUrl else {
            return
        }
        
        var myInfo: StudentLocationArray?
        print("Query URL: \(newUrl.url!)")
        let request = URLRequest(url: newUrl.url!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
                
            }
            let decoder = JSONDecoder()
            
            do {
                var myInfo = try decoder.decode(StudentLocationArray.self, from: data!)
                
                
                if myInfo.results.count >= 1 {
                    print("There exist a student, wanna overwrite")
                    completionHandler(myInfo, nil)
                }
                
                
            } catch {
                print("Error Occured: \(error.localizedDescription)")
                completionHandler(nil, error)
                
            }
            
        }
        
        task.resume()
    }
   
}
