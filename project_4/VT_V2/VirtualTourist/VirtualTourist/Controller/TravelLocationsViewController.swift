//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Abdulaziz Asiri on 5/30/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedPin: Pin?
    
    var savedPin: [Pin] = []
    var newPin: Pin?
    var test: Bool?
    @IBOutlet weak var mapPins: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapPins.delegate = self
        loadData()
        
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        print("Click me first")
     
     
        if let annotation = view.annotation as? PinDataModelAnnoation {
            print("Annotation:  \(annotation.coordinate)")
            print("New Pin : \(newPin?.latitude) \(newPin?.longitude)")

            for i in savedPin {
          
                if annotation.coordinate.latitude == i.latitude && annotation.coordinate.longitude == i.longitude {
                    print("This is what we are looking for")
                          print("Clicked on it,")
                    self.selectedPin = i // This is the selectedPin. Parent.
                    self.test = false
                    print("seleced pin is: \(selectedPin)")
                    performSegue(withIdentifier: "showAlbumSegue", sender: self)
                    print("calling")
                    break
        
                }
            }
        }
    }
    
    @IBAction func loadAnotherrSet(_ sender: UIButton) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumSegue" {
            let secondVC = segue.destination as! PhotoAlbumViewController
            secondVC.test = self.test
            secondVC.receivedPin = self.selectedPin // This is the pin.
        }
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.mapPins)
        
        
        let coords = self.mapPins.convert(location, toCoordinateFrom: self.mapPins)
        print("Coordds we found were:   \(coords)") // Newly creared
        
        var annotation = PinDataModelAnnoation(coordinate: coords)
        
        
        if (sender.state == UIGestureRecognizer.State.ended) {
            self.mapPins.addAnnotation(annotation)

            print("Saved")
            savedData()
            return
        }
        
        if (sender.state == UIGestureRecognizer.State.began)  {
//            if (coords.latitude == 0.0 || coords.longitude == 0.0) {
//                return
//            }
            self.newPin = Pin(context: self.context) //
        
            newPin!.latitude = coords.latitude
            newPin!.longitude = coords.longitude
            self.savedPin.append(newPin!)
        }
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
            print("Annotation now is:  \(i.latitude) and \(i.longitude)")
            var createTempAnnotation = PinDataModelAnnoation(coordinate: CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
            
            self.mapPins.addAnnotation(createTempAnnotation)
        }
    }
    
    
    
    
    
}

