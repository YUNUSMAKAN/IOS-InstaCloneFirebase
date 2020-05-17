//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by MAKAN on 2.05.2020.
//  Copyright © 2020 YUNUS MAKAN. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     //Resme tiklayip secme islemi.
        imageView.isUserInteractionEnabled = true
        let gestureRecignizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecignizer)
    }
    
    
    
    //Resim secme fonksiyonu
    @objc func chooseImage (){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    // Kullanici resim secince ne olucak burada onu belirtiriz.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput:String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference() // bu referanslari kullanarak hangi klasorle calisacagimizi hangi klasore kaydedecegimizi belirtiyoruz.
        let mediaFolder = storageReferance.child("media") // child bir alt kademeye gidebilmeyi saglar.Yani media klasorune gittik vs.
        
        // resimi dataya cevirip kaydetme islemi
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString //her gorsele farkli id/isim ureticek.
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                 
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    imageReferance.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReferance : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl! , "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any]
                            
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost , completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                }else {
                                    self.imageView.image = UIImage(named: "Select")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 // bu bizi feed kismina goturucek.
                                    
                                }
                            })
                            
                            
                            
                         
                            
                            
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    
}
