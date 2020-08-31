//
//  AuthenticateUser.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/15/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


class AuthniticateUser  {
    var session:SuccessSession?
    
    func checkUserAvalibaility(user: String, password:String,  completionHandler: @escaping (Bool?, SuccessSession?,Error?) -> Void) {
        
        
        let user = User(username: user, password: password)
        
        let udacityUser = Udacity(udacity: user)
        let encoder = JSONEncoder()
        
        let json = try? encoder.encode(udacityUser)
        
        
        guard let newJson = json else {
            return
        }
        
    
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = newJson
        
        
        
        var session = URLSession.shared
        let task = session.dataTask(with: request ){ data, response, error in
            if error != nil {
                completionHandler(nil, nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            
            print("String is: user\(String(data: newData!, encoding: .utf8)!)")
            
            do {
                
                self.session = try  decoder.decode(SuccessSession.self, from: newData!)
                print("The seeesion is: \(self.session)")
                completionHandler(true, self.session, nil)
                
            } catch {
                print("Error Occurred: \(error.localizedDescription)")

                completionHandler(false, nil, error)
            }
        }

        task.resume()
    }
    
        
    
}
