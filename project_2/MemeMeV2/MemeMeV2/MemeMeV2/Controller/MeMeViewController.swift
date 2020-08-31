

import UIKit

class MeMeViewController: UIViewController , UITabBarDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var shareButton: UIButton?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var topComment: UITextField!
    @IBOutlet weak var bottomComment: UITextField!
    
    
  
   

    var capturedImage:UIImage! // For takin picturex
    var trigger = false
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        imageView.image = capturedImage
        tabBar.delegate = self
        topComment.delegate = self
        bottomComment.delegate = self

        

        shareButton?.isEnabled = trigger
        configure(textField: topComment)
        configure(textField: bottomComment)
     

      
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
    
    func configure(textField: UITextField) {
        topComment.defaultTextAttributes = memeTextAttributes
             bottomComment.defaultTextAttributes = memeTextAttributes
             
             topComment.textAlignment = .center
             bottomComment.textAlignment = .center
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBar.items?[0].isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    
       subscribeToKeyboardNotifications()
       subScribeKeyboardHide()
    


    }
  

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

    
        unsubscribeFromKeyboardHide()
        unsubscribeFromKeyboardNotifications()

    }
    



    @IBAction func cancelAction(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
        
    }
    
 
    @IBAction func shareAction(_ sender: Any) {
   
       let generatedImage = generateMemedImage()

           let activityController = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)

        
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                    self.save()
                    self.dismiss(animated: true, completion: nil)
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    
     
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    

    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            print("open the album")
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)

        } else {

          

            performSegue(withIdentifier: "cameraSegue", sender: CameraViewController.self)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
       

        dismiss(animated: true, completion: nil)
        shareButton?.isEnabled = true
    }
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomComment.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardHide(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    
}
    
    func subScribeKeyboardHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
         
    }
    func generateMemedImage() -> UIImage {

        
        self.tabBar.isHidden = false
      

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    
        
        
        let memedImageMain:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        
        return memedImageMain
    }
    
    func save() {
        
 
        var editedImage = generateMemedImage()

        editedImage = resizeImage(image: editedImage) // New image to resize  the image after they change dimentions
        
        let meme = Meme(topComment: topComment.text!, bottomComment: bottomComment.text!, originalImage: imageView.image!, editedImage: editedImage)

        (UIApplication.shared.delegate as! AppDelegate).memeData.append(meme)
        print(editButtonItem)

    }
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size

        let widthRatio  = 200  / size.width
        let heightRatio = 200 / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }


        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    

}
