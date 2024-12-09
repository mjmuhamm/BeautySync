//
//  UserBeauticiansTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/17/24.
//

import UIKit

class UserBeauticiansTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var beauticianPassionStatement: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    var userImageButtonTapped : (() -> ()) = {}
    var userLikeButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func userImageButtonPressed(_ sender: Any) {
        userImageButtonTapped()
    }
    
    @IBAction func userLikeButtonPressed(_ sender: Any) {
        userLikeButtonTapped()
    }
    
}
