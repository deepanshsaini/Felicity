//
//  FelicityUserProfileVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 06/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class FelicityUserProfileVC: UIViewController {

    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
       // self.menuBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menuBar(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postRef = Database.database().reference().child("users").child("profile/\(uid)")
        
        postRef.observe(.value) { (snapShot) in
            
            
            
            let value = snapShot.value as? NSDictionary
            let profileImage = value?["photoURL"] as? String
            let username = value?["username"] as? String
            
            let storageRef = Storage.storage().reference(forURL: profileImage!)
            storageRef.getData(maxSize:1*1024*1024, completion: { (data, error) in
                
                let pimage = UIImage(data: data!)
                self.profileImage.image = pimage
                
            })
            
            
            self.usernameLbl.text = username
        }
        
    }
    
    
    @IBAction func logOut(_ sender:  UIButton ){
        try! Auth.auth().signOut()
        
    }
    

   

}
