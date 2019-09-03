//
//  GroupFeedCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 08/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var memberLbl: UILabel!
    //@IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    func configureCell(titleLbl: String, memberLbl: Int) {
        self.titleLbl.text = titleLbl
       // self.descriptionLbl.text = descriptionLbl
       // self.memberLbl.text = "\(memberLbl)"
    }

}
