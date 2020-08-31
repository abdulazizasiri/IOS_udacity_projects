//
//  UserAuthentication.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/7/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation



struct Udacity : Codable {
    let udacity: User
}

struct User: Codable {
    let username:String
    let password: String
    
}

