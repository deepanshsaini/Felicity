//
//  CreateGroupVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 08/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
   // @IBOutlet weak var descripitionTextField: UITextView!
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var groupMemeberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupProfileImage : UIImageView!

    var emailArray = [String]()
    var chosenUserArray = [String]()
    var imagePicker : UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CreateGroupVCTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "CreateGroupVCTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        emailSearchTextField.delegate = self
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        groupProfileImage.isUserInteractionEnabled = true
        groupProfileImage.addGestureRecognizer(imageTap)
        groupProfileImage.layer.cornerRadius = groupProfileImage.bounds.height / 2
        groupProfileImage.clipsToBounds = true
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        if emailSearchTextField.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })
        }
    }

    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        guard let image = groupProfileImage.image else { return }
        
        if titleTextField.text != ""  {
            DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                // upload groups image
                
                self.uploadProfileImage(image, completion: { (url) in
                    if url != nil{
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.commitChanges(completion: { (error) in
                            if error == nil{
                                DataService.instance.createGroup(withTitle: self.titleTextField.text!, groupProfileImage: url!, forUserIds: userIds, handler: { (groupCreated) in
                                    if groupCreated {
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        print("Group could not be created. Please try again.")
                                    }
                                })
                            }
                        })
                    }
                })
                
                
            })
            
            
        }
        
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("groups/\(uid)")
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}

extension CreateGroupVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupVCTableViewCell") as? CreateGroupVCTableViewCell else {return UITableViewCell()}
       let profileImage = UIImage(named: "defaultProfileImage")
        if chosenUserArray.contains(emailArray[indexPath.row]){
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        }else{
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateGroupVCTableViewCell else { return }
        if !chosenUserArray.contains(cell.userEmailIdLbl.text!){
            chosenUserArray.append(cell.userEmailIdLbl.text!)
           groupMemeberLbl.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false

        }else{
            chosenUserArray = chosenUserArray.filter({ $0 != cell.userEmailIdLbl.text! })
            if chosenUserArray.count >= 1{
                groupMemeberLbl.text = chosenUserArray.joined(separator: ", ")

            }else{
                groupMemeberLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
    
    

}

extension CreateGroupVC: UITextFieldDelegate{
    
}

extension CreateGroupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.groupProfileImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}





