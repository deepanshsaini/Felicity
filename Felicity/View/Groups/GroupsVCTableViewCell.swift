//
//  GroupsVCTableViewCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 16/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class GroupsVCTableViewCell: UITableViewCell {

    @IBOutlet weak var groupProfileImage: UIImageView!
    //@IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
//    func configureCell(titleLbl: String, groupProfileImage: UIImage) {
//
//        self.titleLbl.text = titleLbl
//
//        self.groupProfileImage.image = groupProfileImage
//    }
    
    func set(group : Group){
        ImageService.getImage(withURL: group.photoURL) { (image) in
            self.groupProfileImage.image = image
        }
        self.titleLbl.text = group.groupTitle
    }
    
    
}
