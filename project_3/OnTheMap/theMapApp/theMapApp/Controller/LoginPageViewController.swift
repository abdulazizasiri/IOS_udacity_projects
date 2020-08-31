//
//  ViewController.swift
//  theMapApp
//
//  Created by Abdulaziz Asiri on 5/6/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit
import Foundation
class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    static var session: SuccessSession?
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.isEnabled = false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason){
        
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginButton.isEnabled = true
            print("End")
        }
        
        self.loginButton.isEnabled = true
        //        print("REASONS: \(reason)")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func authnticateUser(_ sender: Any) {
        
        // Authenticate Users
        let username = emailTextField.text
        let password = passwordTextField.text
        var test = self.isValidEmail(username!)
        
        if username! == "" || password == "" {
            self.printError(errorText:  "Email or password is not provided")
            return
        }
        
        
        if !test {
            self.printError(errorText:  "Email is not Valid")
            return
        }
        
        
        var auth = AuthniticateUser()
        auth.checkUserAvalibaility(user: username!, password: password!) { (flag,session, error) in
            if error != nil {
                self.printError(errorText:"No Internet Connection found")
                return
            }
            guard let unwrapedFlag = flag else {
                
                print("Nothing has  been passed ")
                return
            }
            if (unwrapedFlag) {
                DispatchQueue.main.async {
                    self.errorMsg.text = ""
                }
                LoginPageViewController.session = session
                
                self.openSegue(segueName: "mapSegue")
                
            } else {
                
                self.printError(errorText: "Email or password is Incorrect")
            }
            
        }
        
    }
    
    
    func openSegue(segueName: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: segueName, sender: self)
        }
    }
    
    func printError(errorText: String) {
        DispatchQueue.main.async {
            self.errorMsg.text = errorText
            self.errorMsg.textColor = .red
            self.errorMsg.textAlignment = .center
        }
        
    }
    
    @IBAction func authinticateFacebookUSer(_ sender: Any) {
        
        errorMsg.text = "I will Implement it soon"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPred.evaluate(with: email)
    }
    
}

