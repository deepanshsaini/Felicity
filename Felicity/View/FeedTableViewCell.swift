//
//  FeedTableViewCell.swift
//  Felicity
//
//  Created by Deepansh Saini on 05/08/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView : UIView!
    @IBOutlet weak var postTextLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = #colorLiteral(red: 0.2329619552, green: 0.2537529211, blue: 0.2678656409, alpha: 1)
        cellView.layer.shadowOpacity = 12
        cellView.layer.opacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post: Post){
        
        ImageService.getImage(withURL: post.author.photoURL) { (image) in
            self.profileImageView.image = image
        }
        usernameLbl.text = post.author.username
        postTextLbl.text = post.text
    }
    
}
