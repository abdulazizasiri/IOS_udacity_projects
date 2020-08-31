//
//  PostNewStudentLocationViewController.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/9/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

import MapKit

class PostNewStudentLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var newStudent: StudentLocation?
    var updatedStudent: StudentLocation?
    @IBOutlet weak var locationName: UITextField!
    var objectId: String = ""
    
    var secondVC: AddNewLocationViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.delegate = self
        indicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        subscribeToKeyboardNotifications()
        subScribeKeyboardHide()
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if locationName.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func subScribeKeyboardHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        locationName.text = ""
        
        locationName.textColor = .white
    }
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        locationName.textAlignment = .center
    }
    
    @IBAction func postNewLocation(_ sender: Any) {
        
        if locationName.text == "" {
            locationName.text = "No location was providede"
            locationName.textColor = .red
            
        } else {
            
            self.secondVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewLocationViewController") as? AddNewLocationViewController
            if (objectId == "") {
                
                
                newStudent = StudentLocation(createdAt: "", firstName: StudentCredentials.firstName, lastName: StudentCredentials.lastName, latitude: 0.0, longitude: 0.0, mapString: locationName.text!, mediaURL: "", objectId: objectId, uniqueKey: StudentCredentials.myUniqueId, updatedAt: "")
                self.secondVC?.isNew = true
                self.secondVC?.isUpdated = false
                
                validateLocation(studentLocation: newStudent!)

            } else {
                updatedStudent = StudentLocation(createdAt: "", firstName: StudentCredentials.firstName, lastName: StudentCredentials.lastName, latitude: 0.0, longitude: 0.0, mapString: locationName.text!, mediaURL: "", objectId: objectId, uniqueKey: StudentCredentials.myUniqueId, updatedAt: "")
                
                self.secondVC?.isUpdated = true
                self.secondVC?.isNew = false
         
                validateLocation(studentLocation: updatedStudent!)

            }

        }
        
        
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func validateLocation(studentLocation: StudentLocation) {
        var pin: StudentAnnotation?
        pin = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), title: "", subtitle: "")
        
        var tempStudent = studentLocation
        placeMark(annotation: pin!) { (placemark) in
            
            var location = studentLocation
            
            if let placemark = placemark {
                tempStudent.latitude = placemark.location?.coordinate.latitude as! Double
                tempStudent.longitude = placemark.location?.coordinate.longitude as! Double
                pin = StudentAnnotation(coordinate: placemark.location!.coordinate, title: tempStudent.firstName + " " + tempStudent.lastName, subtitle:     tempStudent.mediaURL)
                
                location = StudentLocation(createdAt: "", firstName: StudentCredentials.firstName, lastName: StudentCredentials.lastName, latitude: (pin?.coordinate.latitude)!, longitude: (pin?.coordinate.longitude)!, mapString: self.locationName.text!, mediaURL: "", objectId: self.objectId, uniqueKey: StudentCredentials.myUniqueId, updatedAt: "")
                
                print("PIN  from POST  \(pin?.coordinate)")
                
                if self.objectId == "" {
                     self.secondVC?.newUser = location
                } else {
                     self.secondVC?.updatedStudent = location
                }
                
               
                
                self.secondVC?.pin = pin
                
                self.present(self.secondVC!, animated: true, completion: nil)
                
            } else {
   
                self.alertErrors(location: self.locationName.text!)
            }
        }
        
        
    }
    func alertErrors(location: String) {
        var alertController = UIAlertController(title: "Error", message: "Couldn't find the location \(location). Please provide a valid location", preferredStyle: .alert)
        
        var cancelAction = UIAlertAction(title: "Try Again", style: .cancel) { (UIAlertAction) in
            self.locationName.text = "Enter Your Location Here"
        }
        
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true)
        
        
    }
    
    func placeMark(annotation: StudentAnnotation,  completionHandler: @escaping  (CLPlacemark?) -> Void) {
        
        let coordinate =  annotation.coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let geocoder = CLGeocoder()
        
        if newStudent != nil {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            geocoder.geocodeAddressString(newStudent!.mapString) { (placemarks, error) in
                if let placemarks = placemarks {
                    completionHandler(placemarks.first)
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true

                }
                else {
                    completionHandler(nil)
                }
            }
        }
        if updatedStudent != nil {
            self.indicator.isHidden = false
            self.indicator.startAnimating()

            geocoder.geocodeAddressString(updatedStudent!.mapString) { (placemarks, error) in
                if let placemarks = placemarks {
                
                    completionHandler(placemarks.first)
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true

                }
                else {
                    completionHandler(nil)
                    
                    
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    
}
