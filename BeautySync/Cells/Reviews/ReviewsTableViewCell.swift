//
//  ReviewsTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/21/24.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var itemThoughts: UILabel!
    
    @IBOutlet weak var userLikeImage: UIImageView!
    @IBOutlet weak var userLikes: UILabel!
    
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var expectationsLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
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
