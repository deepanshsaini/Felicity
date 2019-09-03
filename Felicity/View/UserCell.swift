//
//  UserCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 08/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userEmailIdLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    
    var showing  = false
    
    func configureCell(profileImage image : UIImage,email : String,isSelected : Bool){
        self.profileImage.image = image
        self.userEmailIdLbl.text = email
        if isSelected{
            self.checkImage.isHidden = false
        }else{
            self.checkImage.isHidden = true
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if showing == false{
                checkImage.isHidden = false
                showing = true
                
                } else {
                checkImage.isHidden = true
                showing = false
            }
        }
        
    }

}
