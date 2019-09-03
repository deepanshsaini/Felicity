//
//  HappinessSignUpViewController.swift
//  Felicity
//
//  Created by Deepansh Saini on 04/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class HappinessSignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker:UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func handleSignUp(_ sender: UIButton) {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let image = profileImageView.image else { return }
        
        
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                
                // 1. Upload the profile image to Firebase Storage
                
                self.uploadProfileImage(image) { url in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(username: username, email: email, profileImageURL: url!) { success in
                                    if success {
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        self.resetForm()
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                                self.resetForm()
                            }
                        }
                    } else {
                        self.resetForm()
                    }
                    
                }
                
            } else {
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { (url, error) in
                    if error == nil && url != nil  {
                        completion(url)
                    }
                }
            
            } else {
                // failed
                completion(nil)
            }
        }
        
        
    }
    
    
    
    func saveProfile(username:String,email : String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "email": email,
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
            
            
        
        }
    }
    
    
    
    @IBAction func dismissBtnPressed(_ sender : UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension HappinessSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

