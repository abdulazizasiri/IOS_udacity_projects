//
//  ViewController.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/22/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class TravelLocationsMapView: UIViewController, MKMapViewDelegate{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedPin: Pin?

    var savedPin: [Pin] = []
    var newPin: Pin?
    var images: [ActualImages]?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView.delegate = self
        loadData()
//        print("Saved pins: \(savedPin)")

    }
    
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? PinDataModelAnnoation {





            for i in savedPin {
                if annotation.coordinate.latitude == i.lat && annotation.coordinate.longitude == i.long {
                    print("This is what we are looking for")
                    self.selectedPin = i
                }
            }
            
            print("seleced pin is: \(annotation)")
            performSegue(withIdentifier: "showDetails", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            let secondVC = segue.destination as! PhotoAlbumViewController
            print("The pin slected:  \(self.selectedPin)")
            secondVC.selectedPin = self.selectedPin
            secondVC.actualImages = self.images
     print("The actual copied Images:  \(secondVC.actualImages)")

            print("The actual original Images:  \(self.images)")

        }
    }
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        

        let location = sender.location(in: self.mapView)
        
        
        
        let coords = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        var annotation = PinDataModelAnnoation(coordinate: coords)

        // Set the lat and long
        ImagesMetaData.latitude = String(coords.latitude)
        ImagesMetaData.longitude = String(coords.latitude)
        ImagesMetaData.perPage = String(50)
        
        
        if (sender.state == UIGestureRecognizer.State.ended) {
                    print("SAved Ended")
             savedPin.append(newPin!)
            
            
            ImagesMetaData.requestData { (imagesData, error) in
                                   if error != nil {
                                       // Print error alerting the user
                                       print("Error Occured: \(error?.localizedDescription)")
                                   }

                           print("self images:  \(self.images)")
                           self.images = imagesData?.photos.photo
                
                       }
            self.mapView.addAnnotation(annotation)
                       
                             savedData()
            
            
            return
            
        }
        
        if (sender.state == UIGestureRecognizer.State.began) {
            
            print("Saved Began")
            
        
          
            
            if (coords.latitude == 0.0 || coords.longitude == 0.0) {
                
                


                return
            }
            
    
            self.newPin = Pin(context: self.context) //

            newPin!.lat = coords.latitude
            newPin!.long = coords.longitude
            selectedPin = newPin
        }
        print("Added location")
    }
    func savedData () {
       
        do {
            print("Saved First")
            
            try self.context.save()
        } catch {
            print("Some Errror has Occured:   \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
           savedPin =  try self.context.fetch(request)
            print("The size of saved pins:  \(savedPin.count)")
        } catch {
            print("Error Occured while loading up the data. \(error.localizedDescription)")
            
        }
        
        placePins()
    }
    
    func placePins() {
        for i in  savedPin {
            print("Annotation now is:  \(i.lat) and \(i.long)")
            var createTempAnnotation = PinDataModelAnnoation(coordinate: CLLocationCoordinate2D(latitude: i.lat, longitude: i.long))
            
            self.mapView.addAnnotation(createTempAnnotation)
        }
    }
    
   
}

