//
//  GroupFeedVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 06/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase
class GroupsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "GroupsVCTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "GroupsVCTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
extension GroupsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsVCTableViewCell", for: indexPath) as?  GroupsVCTableViewCell
//        let group = groupsArray[indexPath.row]
        
//        cell?.configureCell(titleLbl: group.groupTitle, groupProfileImage: group.photoURL )
        cell?.set(group: groupsArray[indexPath.row])
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedViewController") as? GroupChatVC else { return }
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        present(groupFeedVC, animated: true, completion: nil)
    }
}
