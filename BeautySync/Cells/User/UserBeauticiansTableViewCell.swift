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
    
    var userImageButtonTapped : (() -> ()) = {}
    var userLikeButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
