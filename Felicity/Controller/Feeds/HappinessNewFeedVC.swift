//
//  HappinessNewFeedVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 05/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class HappinessNewFeedVC: UIViewController{
    
    @IBOutlet weak var feedView : UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.bindToKeyboard()
        textViewDidBeginEditing(feedView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        feedView.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            super.dismiss(animated: flag, completion: completion)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    

    @IBAction func postBtnPressed(_ sender: UIButton){
        guard let userProfile = UserService.currentUserProfile else{return}
        
        // Firebase uploadation Code here
        let postRef  = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": userProfile.uid,
                "username" : userProfile.username,
                "photoURL" : userProfile.photoURL.absoluteString
            ],
            "text": feedView.text,
            "timestamp":[".sv":"timestamp"]
        ] as [String:Any]
        
        postRef.setValue(postObject) { (error, ref) in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                //hanle error
                
            }
        }
    }

    
    
    
    
}

extension HappinessNewFeedVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = " "
    }
}


