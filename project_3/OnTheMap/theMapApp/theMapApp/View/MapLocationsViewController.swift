
import UIKit
import MapKit
class MapLocationsViewController: UIViewController , MKMapViewDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeStudentInfoRequest()
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
   
        
        mapView.reloadInputViews()
        
    }
     func printFriendlyError() {
        let alertController = UIAlertController(title: "Wrong Location", message: "The URL used to get Students location is Invalid", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            
        }
        alertController.addAction(yesAction)
    self.present(alertController, animated: true)

    }
    @IBAction func logout(_ sender: Any) {
        let alertController = UIAlertController(title: "Log Out", message: "Do you want to log out? ", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel) { (UIAlertAction) in
            
        }
        
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            Unauthentication.removeSession()
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("I am clling this annotation")
        if let anotation = view.annotation as? StudentAnnotation {
            let Checkurl = verifyUrl(urlString: anotation.subtitle!)
            if !Checkurl {
                printUnavailableLocation()
            }
            
            if let url = URL(string: anotation.subtitle!) {
                
                UIApplication.shared.open(url)
            }
          
            
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
    func presentAlert(objectId: String, updatedStuddent: StudentLocation){
        var alertController = UIAlertController(title: "Note", message: "You have Already Posted a Student Location. Would You Like to Overwrite Your Current Location", preferredStyle: .alert)
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
           
        }
        
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (UIAlertAction) in
            
            
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "PostNewStudentLocationViewController") as! PostNewStudentLocationViewController
            
            secondVC.objectId = objectId
            secondVC.updatedStudent = updatedStuddent
            self.present(secondVC, animated:true, completion:nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(overwriteAction)
        
        
        
        self.present(alertController, animated: true)
    }
    
    @IBAction func loadStudents(_ sender: Any) {
        makeStudentInfoRequest()
    }
    
    func checkLength (items: StudentLocationArray) -> Bool {
        if items.results.count >= 1 {
            return false
        }
        
        return true
    }
    
    @IBAction func addMyLocation(_ sender: Any) {
        StudentsExistnceChecker.udateStudentInfo { (myInfo, error) in
            if myInfo != nil {
                if (myInfo?.results.count)! > 0 {
                    print("THE LENGTH FOUND WAS :    \( (myInfo?.results.count))")
                    DispatchQueue.main.async {
                        self.presentAlert(objectId: myInfo!.results[myInfo!.results.count-1].objectId, updatedStuddent: myInfo!.results[myInfo!.results.count-1])
                    }
                }
            } else {
                print("Error :   \(error?.localizedDescription)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addLocationSegue", sender: nil)
                }
            }
            
        }
    }
    
    func makeStudentInfoRequest() {
        MakeNetworkCall.makeStudentsREquests { (allStudents, error) in
            if error != nil {
                self.printFriendlyError()
                print("While making the request an error occured")
            }
            
            guard let allStudentReturned = allStudents?.results else {
                return
            }
            for record in allStudentReturned {
                let longitude = CLLocationDegrees(record.longitude)
                let latitude = CLLocationDegrees(record.latitude)
                let coord = CLLocationCoordinate2DMake(latitude, longitude)
                DispatchQueue.main.async {
                    let pint = StudentAnnotation(coordinate: coord, title: record.firstName + " " + record.lastName, subtitle: record.mediaURL)
                    self.mapView.addAnnotation(pint)
                }
            }
           
        }
        
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
