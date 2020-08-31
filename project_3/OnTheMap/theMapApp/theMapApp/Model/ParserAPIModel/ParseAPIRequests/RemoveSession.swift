//
//  RemoveSession.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/18/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation

class Unauthentication {
    
    class func removeSession(){
    
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        

        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        do {
            
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
                
            }
            
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                print("REQUEST SEND ID:   \(request)")
                if error != nil { // Handle error…
                    return
                    
                }
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print("SEssion Success: \(String(data: newData!, encoding: .utf8))!")
            }
            task.resume()
        }
    }
}
