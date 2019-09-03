//
//  GroupInfoVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 17/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class GroupInfoVC: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupImage : UIImageView!
    @IBOutlet weak var doneBtn : UIButton!
    @IBOutlet weak var groupMemeberLbl : UILabel!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "GroupInfoVCTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GroupInfoVCTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource =  self
        emailSearchTextField.delegate = self
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    @IBAction func cancelBtnPressed (_ sender : UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
            var userIds = idsArray
            userIds.append((Auth.auth().currentUser?.uid)!)
            
            DataService.instance.editGroup( forUserIds: userIds, handler: { (groupCreated) in
                if groupCreated {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Group could not be created. Please try again.")
                }
            })
        })
    
    
    
    }
        

    

}

extension GroupInfoVC : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupInfoVCTableViewCell") as? GroupInfoVCTableViewCell else {return UITableViewCell()}
        let profileImage = UIImage(named: "defaultProfileImage")
        if chosenUserArray.contains(emailArray[indexPath.row]){
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        }else{
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
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
