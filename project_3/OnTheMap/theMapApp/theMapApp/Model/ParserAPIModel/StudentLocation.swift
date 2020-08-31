  
//
//  StudentLocation.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/8/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//
import Foundation

struct StudentLocationArray : Codable {
    let results: [StudentLocation]
}
struct StudentLocation: Codable{
    let createdAt: String
    let firstName: String
    let lastName:String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    let objectId:String
    let uniqueKey:String
    let updatedAt:String
}
