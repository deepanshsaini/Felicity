//
//  GroupChatVCTableViewCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 16/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class GroupChatVCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = #colorLiteral(red: 0.2329619552, green: 0.2537529211, blue: 0.2678656409, alpha: 1)
        cellView.layer.shadowOpacity = 12
        
    }
    
    func configureCell(profileImage: UIImage, emailLbl: String, content: String) {
     
        self.contentLbl.text = content
    }
    
}
