//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Abdulaziz Asiri on 4/26/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITabBarDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

//    let memeTextAttributes: [NSAttributedString.Key: Any] = [
//        NSAttributedString.Key.strokeColor: UIColor.white,
//        NSAttributedString.Key.foregroundColor: UIColor.white,
//        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
//        NSAttributedString.Key.strokeWidth: 1
//    ]
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    enum TabBarIttems: Int{
        case album = 1
        case picture
        case cancel
        case share
        
    }
    @IBOutlet weak var topComment: UITextField!
    

    @IBOutlet weak var bottomComment: UITextField!
    @IBOutlet var tabs: [UITabBar]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
     
        
         tabs[0].delegate = self
        tabs[1].delegate = self
        topComment.delegate = self
        bottomComment.delegate = self
        
        
//        topComment.defaultTextAttributes = memeTextAttributes
//        bottomComment.defaultTextAttributes = memeTextAttributes
        
        let toolBar = UIToolbar()
             toolBar.sizeToFit()
             let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClick))
             
             toolBar.setItems([doneButton], animated: true)
             topComment.inputAccessoryView = toolBar
   }
    
    @objc func doneClick() {
        view.endEditing(true)
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("I am done")
    }
   override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.tag == 1 {
            print("Album")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary

           
            

            present(imagePicker, animated: true, completion: nil)
        } else if item.tag == 2 {
            print("Take a picture")
        } else if item.tag == 3 {
            print("Cacnel")
            dismiss(animated: true, completion: nil)
        } else {
         let images = UIImage()

         let controller = UIActivityViewController(activityItems: [images], applicationActivities: nil)

         present(controller, animated: true, completion: nil)

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    imagePickerView.image = image
    dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {

        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
   func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }


    
    
   func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}
