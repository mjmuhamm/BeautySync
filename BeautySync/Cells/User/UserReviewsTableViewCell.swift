//
//  UserReviewsTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/17/24.
//

import UIKit

class UserReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTypeAndTitle: UILabel!
    @IBOutlet weak var beautician: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userThoughts: UILabel!
    @IBOutlet weak var doesTheUserRecommend: UILabel!
    
    @IBOutlet weak var expectations: UILabel!
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var beauticianRating: UILabel!
    
    @IBOutlet weak var userLikeImage: UIImageView!
    @IBOutlet weak var userLikes: UILabel!
    
    
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
