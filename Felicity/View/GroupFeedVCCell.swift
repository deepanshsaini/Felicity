//
//  GroupFeedVCCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 09/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class GroupFeedVCCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    func configureCell(profileImage: UIImage, emailLbl: String, content: String) {
        self.profileImage.image = profileImage
        self.emailLbl.text = emailLbl
        self.contentLbl.text = content
    }

}
