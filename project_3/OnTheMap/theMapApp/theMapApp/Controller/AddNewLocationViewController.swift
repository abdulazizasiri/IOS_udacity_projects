
import UIKit
import MapKit
class AddNewLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tinyMap: MKMapView!
    @IBOutlet weak var linkURL: UITextField!
    var updatedStudent: StudentLocation?
    var isUpdated: Bool?
    var isNew: Bool?
    var newUser: StudentLocation?
    var pin: StudentAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkURL.delegate = self
        //        checkLocationAvailability()
        
        postPin()
    }
    
    
    func postPin() {
        guard let pin = pin else {
            
            print("This is still NIL ")
            return
        }
        print("PIN  from ADD  \(pin.coordinate)")
        
        let camera = MKMapCamera()
        camera.centerCoordinate = pin.coordinate
        camera.altitude = 1000.0
        tinyMap.addAnnotation(pin)
        tinyMap.camera = camera
    }
    
    func checkLocationAvailability(){
        
        guard let new = isNew, let old = isUpdated else {
            print("ALL BAD ")
            return
        }
        
        if new {
            
            guard let newUser = newUser else {
                return
            }
            
            addToAPI()
        }
        
        if old {
            guard let updatedStudent = updatedStudent else {
                return
            }
            print("Old Students")
            UpdateAPI()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        view.frame.origin.y = 0
        
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        linkURL.text = ""
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postData(_ sender: Any) {
        
        checkLocationAvailability()
//        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        
//        print("Before finihing:   \(linkURL.text!)")
//        secondVC.modalPresentationStyle = .fullScreen
//        present(secondVC, animated: true, completion: nil)
//
//
        dismiss(animated: true, completion: nil)
    }
    
    func addToAPI (){
        var trimmedUrl = clearnString()
        newUser?.mediaURL = trimmedUrl
        print("THE NEW USER:   \(String(describing: newUser))")
        PostStudent.postDtudent(newUser: newUser!) { (test, error) in
            guard let check = test else {
                return
            }
            if check {
                print("Sucess ")
                return
            }
            self.userFriendlyError()
            print("Erroroccured:  \(error?.localizedDescription)")
            
        }
        
    }
    
    func UpdateAPI() {
        
        var trimmedUrl = clearnString()
        updatedStudent?.mediaURL = trimmedUrl
        
        print("The Updated student now becomes   \(updatedStudent)")
        print("Link URL:   \( linkURL.text!)")
        print("Student location:   \(updatedStudent?.mediaURL)")
        UpdateStudent.updateStudent(updatedStudent: updatedStudent!) { (check, error) in
            guard let check = check else {
                return
            }
            
            if check {
                print("Sucess ")
                return
            }
            self.userFriendlyError()
            print("Erroroccured:  \(error?.localizedDescription)")
            
        }
        
        
    }
    
    func clearnString() -> String {
        let trimmed = linkURL.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmed
        
    }
    
    
    func userFriendlyError () {
        var alertController = UIAlertController(title: "Error", message: "Couldn't find the location. Please provide a valid location", preferredStyle: .alert)
        
        var cancelAction = UIAlertAction(title: "Try Again", style: .cancel) { (UIAlertAction) in
        }
        
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true)
    }
    
}
