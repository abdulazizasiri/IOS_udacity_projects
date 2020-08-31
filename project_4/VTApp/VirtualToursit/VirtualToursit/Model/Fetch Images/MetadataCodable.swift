//
//  MetadataCodable.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/23/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation

struct MainKeys: Codable {
    var photos: Metadata
    var stat: String
}

struct Metadata : Codable{
    var page : Int
    var pages: Int
    var perpage:  Int
    var total : String
    var photo: [ActualImages]
}

struct ActualImages: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String 
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}



