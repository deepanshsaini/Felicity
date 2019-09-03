
//
//  HappinessLogInVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 04/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class HappinessLogInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func handleSignIn(_ sender: UIButton) {
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func dismissBtnPressed(_ sender : UIButton){
        dismiss(animated: true, completion: nil)
    }

}
