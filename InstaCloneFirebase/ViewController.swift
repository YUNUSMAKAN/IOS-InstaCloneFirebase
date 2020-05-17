//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by MAKAN on 28.04.2020.
//  Copyright © 2020 YUNUS MAKAN. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var cloneLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
   //Kayitli kullanici giris islemi.
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdata, error) in
                if error != nil {
                     self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "ERROR")
                }else {
                     self.performSegue(withIdentifier: "toFeedVC", sender: nil)   
                    
                }
            }
        }else {
             makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
    }
    
    //Yeni kullanici firebase e kaydetme islemi.
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "ERROR")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
        }else {
           
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
    }
    
    
    //UYARI MESAJINI BIR FONKSIYONA ATADIK DAHA KOLAY CAGIRLABILELIM DIYE.
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

