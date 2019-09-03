//
//  HappinessAnonymousPicExchangerVC.swift
//  Felicity
//
//  Created by Deepansh Saini on 05/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class HappinessAnonymousPicExchangerVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var screenCoverTapped : UIButton!
    
    
    var tableView: UITableView!
    
    var posts = [Post]()
    
    
    @IBOutlet weak var tableViewVC : UIView!
    
    override func viewDidLoad(){
        
        
        super.viewDidLoad()
        
        
        
        
        
        
        
        tableView = UITableView(frame: tableViewVC.bounds, style: .plain)
        tableViewVC.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableViewVC.addSubview(tableView)
        //view.addSubview(tableView)
        
        
        let cellNib = UINib(nibName: "FeedTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        var layoutGuide : UILayoutGuide!
        
        if #available(iOS 11.0, *){
            layoutGuide = view.safeAreaLayoutGuide
        }else{
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        observePosts()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBtnTapped(_ sender : UIButton){
        showMenu()
    }
    
    @IBAction func screenCoverBtnTapped(_ sender:  UIButton ){
        
        hideMenu()
    }
    
    func showMenu() {
        UIView.animate(withDuration: 0.4) {
            
           // self.screenCoverTapped.alpha = 1
        }
    }
    
    func hideMenu(){
        UIView.animate(withDuration: 0.4) {
            
           // self.screenCoverTapped.alpha = 0
        }
    }
    
   
    
    func observePosts() {
        let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                    let post = Post(id: childSnapshot.key, author: userProfile, text: text, timestamp:timestamp)
                    tempPosts.append(post)
                }
            }
            
            self.posts = tempPosts.reversed()
            self.tableView.reloadData()
            
        })
        
    }
    
    @IBAction func logOut(_ sender:  UIButton ){
        try! Auth.auth().signOut()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedTableViewCell
        cell.set(post: posts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    


}
