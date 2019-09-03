//
//  GroupFeedViewController.swift
//  Felicity
//
//  Created by Deepansh Saini on 09/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class GroupChatVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl : UILabel!
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var sendBtnView : UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendBtn : UIButton!
    
    var group : Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group){
        self.group = group
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sendBtnView.bindToKeyboard()
        let cellNib = UINib(nibName: "GroupChatVCTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GroupChatVCTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
          //  self.memberLbl.text = returnedEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessages(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0{
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }

    @IBAction func sendBtnPressed(_ sender : Any){
        if messageTextField.text != ""{
            messageTextField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key) { (complete) in
                if complete{
                    self.messageTextField.text = ""
                    self.messageTextField.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            }
        }
    }

    
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoBtnPressed(_ sender: UIButton){
        guard let GroupInfoVC = storyboard?.instantiateViewController(withIdentifier: "GroupInfoVC") as? GroupInfoVC else { return }
        
        present(GroupInfoVC, animated: true, completion: nil)
    }
    
    
}

extension GroupChatVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatVCTableViewCell", for: indexPath) as? GroupChatVCTableViewCell else {return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, emailLbl: email, content: message.content)
        }
        return cell

    }
    
    
    
    
    
    
}
