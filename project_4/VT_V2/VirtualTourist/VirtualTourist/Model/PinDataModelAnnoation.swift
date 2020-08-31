//
//  PinDataModelAnnoation.swift
//  VirtualTourist
//
//  Created by Abdulaziz Asiri on 5/30/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//


import Foundation


import MapKit

class PinDataModelAnnoation: NSObject, MKAnnotation {
       var coordinate: CLLocationCoordinate2D

       init(coordinate:CLLocationCoordinate2D){
           self.coordinate = coordinate

       }
    
}
