//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by MAKAN on 2.05.2020.
//  Copyright © 2020 YUNUS MAKAN. All rights reserved.
//

import UIKit
import  Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var userEmailArray = [String]()
    var userCommetArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommetArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
       /* let setting = fireStoreDatabase.settings    // tarih otomatik ayarlanmaz ise bu kisimi calistirirdik.
        setting.areTimestampsInSnapshotsEnabled = true
        fireStoreDatabase.settings = setting*/
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in // firestore dan tarihe gore azalarak verileri cekecektir.(.order) ile istedigimiz sekilde dizdirebiliyoruz.
            if error != nil {
                print(error?.localizedDescription)
                
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    
                    //Surekli ustune yazmamasi icin dongunun icini temizlememiz gerekmektedir.
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommetArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                            
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommetArray.append(postComment)
                            
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                            
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                            
                        }
                    }
                
                    self.tableView.reloadData() // datamizi reload edebilmemiz icin gerekli.
                
                
                
                
            }
        }
        
    }
    
}
}

