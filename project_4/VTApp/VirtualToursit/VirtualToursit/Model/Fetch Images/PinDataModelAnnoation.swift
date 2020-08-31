//
//  PinDataModelAnnoation.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/25/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


import MapKit

class PinDataModelAnnoation: NSObject, MKAnnotation {
       var coordinate: CLLocationCoordinate2D
//       var title: String?
//       var subtitle: String?
       

       
       init(coordinate:CLLocationCoordinate2D){
           self.coordinate = coordinate
//           self.title = title
//           self.subtitle = subtitle
    
       }
    
}
