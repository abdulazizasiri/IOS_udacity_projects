//
//  ListLocationsViewController.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/7/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class ListLocationsViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userLocationInfo: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return  MakeNetworkCall.studentRecord!.results.count
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var media =  MakeNetworkCall.studentRecord!.results[indexPath.row].mediaURL
        let Checkurl = verifyUrl(urlString: media)
        if !Checkurl {
            printUnavailableLocation()
        }
        
        var url = MakeNetworkCall.studentRecord!.results[indexPath.row].mediaURL
        if let url = URL(string: url) {
            
            UIApplication.shared.open(url)
        }
        
        
        
        
        
        
    }
    
    func printFriendlyError() {
        let alertController = UIAlertController(title: "Wrong Location", message: "The URL used to get Students location is Invalid", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            
        }
        alertController.addAction(yesAction)
        self.present(alertController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath) as! StudentTableViewCell
        cell.pinLogo?.image = UIImage(named: "icon_pin")
        cell.studentName.text = (MakeNetworkCall.studentRecord!.results[indexPath.row].firstName) + " " + (MakeNetworkCall.studentRecord!.results[indexPath.row].lastName)
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        makeStudentInfoRequest()
        
        
    }
    
    func makeStudentInfoRequest() {
        
        MakeNetworkCall.makeStudentsREquests { (allStudents, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.printFriendlyError()
                    print("While making the request an error occured")
                }
                
                return 
            }
            guard let allStudentReturned = allStudents?.results else {
                return
            }
            self.userLocationInfo.delegate = self
            self.userLocationInfo.dataSource = self
        }
    }
    
    
    
    
    @IBAction func addStudent(_ sender: Any) {
        
        
        
        StudentsExistnceChecker.udateStudentInfo{ (myInfo, error) in
            if myInfo != nil {
                DispatchQueue.main.async {
                    self.presentAlert(objectId: myInfo!.results[myInfo!.results.count-1].objectId, updatedStuddent: myInfo!.results[myInfo!.results.count-1])
                }
                
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addLocationSegue", sender: nil)
                }
            }
        }
        
        
    }
    
    
    @IBAction func loadStudent(_ sender: Any) {
        makeStudentInfoRequest()
    }
    
    func callSegue () {
        
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addLocationSegue", sender: self)
        }
        
    }
    
    func presentAlert(objectId: String, updatedStuddent: StudentLocation){
        var alertController = UIAlertController(title: "Note", message: "You have Already Posted a Student Location. Would You Like to Overwrite Your Current Location", preferredStyle: .alert)
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            //            print("Cancel Action")
        }
        
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (UIAlertAction) in
            
            
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "PostNewStudentLocationViewController") as! PostNewStudentLocationViewController
            
            secondVC.objectId = objectId
            secondVC.updatedStudent = updatedStuddent
            self.present(secondVC, animated:true, completion:nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(overwriteAction)
        
        
        self.present(alertController, animated: true) {
            
        }
    }
    func printUnavailableLocation(){
        var alertController = UIAlertController(title: "Can't Open", message: "Could open the URL for this location", preferredStyle: .alert)
        
        var cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            print("Cancel Action")
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}
