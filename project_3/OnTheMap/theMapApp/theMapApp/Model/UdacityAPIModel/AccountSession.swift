//
//  AccountSession.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/12/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


struct Account: Codable {
    let registered: Bool
    let key: String
}


struct Session: Codable  {
    let id: String
    let expiration: String
}


struct SuccessSession: Codable {
    let account: Account
    let session: Session
}
