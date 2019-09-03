//
//  DataServices.swift
//  Felicity
//
//  Created by Deepansh Saini on 08/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users").child("profile")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "username").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            // send to groups ref
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message,"senderId": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    
    func getAllMessages(desiredGroup : Group, handler : @escaping(_ messagesArray : [Message])->()){
            var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observe(.value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot{
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "username").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "username").value as! String
                
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "username").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String,groupProfileImage : URL, forUserIds ids : [String], handler: @escaping(_ groupCreated : Bool)->()){
        REF_GROUPS.childByAutoId().updateChildValues(["title":title,"photoURL" : groupProfileImage.absoluteString,"members":ids])
        handler(true)
    }
    
    func editGroup(forUserIds ids : [String], handler: @escaping(_ groupCreated : Bool)->()){
        //REF_GROUPS.childByAutoId().updateChildValues(["members":ids])
        REF_GROUPS.observe(.value) { (groupSnapShot) in
            self.REF_GROUPS.childByAutoId().updateChildValues(["members": ids])
        }
        handler(true)
    }
    
    
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let photoURL = group.childSnapshot(forPath: "photoURL").value as! String
                    
                    let photo  =  URL(fileURLWithPath: photoURL)
                    let group = Group(title: title, key: group.key, members: memberArray, memberCount: memberArray.count, photoURL: photo)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    
    
    
}


