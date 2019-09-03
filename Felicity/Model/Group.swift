//
//  Group.swift
//  Felicity
//
//  Created by Deepansh Saini on 09/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class Group {
    private var _groupTitle: String
   // private var _groupDesc: String
    private var _key: String
    private var _memberCount: Int
    private var _members: [String]
    private var _photoURL : URL
    
    var groupTitle: String {
        return _groupTitle
    }
    
    var photoURL : URL{
        return _photoURL
    }
    
    
    var key: String {
        return _key
    }
    
    var memberCount: Int {
        return _memberCount
    }
    
    var members: [String] {
        return _members
    }
    
    init(title: String, key: String, members: [String], memberCount: Int,photoURL : URL) {
        self._groupTitle = title
        
        self._key = key
        self._members = members
        self._memberCount = memberCount
        self._photoURL = photoURL
        
    }
}

    
    
    
    
    
    
    

