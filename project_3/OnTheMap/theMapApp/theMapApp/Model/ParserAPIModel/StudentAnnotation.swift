//
//  StudentAnnotation.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/8/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation

import MapKit

class StudentAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    

    
    init(coordinate:CLLocationCoordinate2D, title:String?, subtitle: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
 
    }
    
 
    
    
}
