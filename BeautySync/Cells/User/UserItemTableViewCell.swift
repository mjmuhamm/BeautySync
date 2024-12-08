//
//  UserItemTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/17/24.
//

import UIKit

class UserItemTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemLikeImage: UIImageView!
    @IBOutlet weak var itemLikes: UILabel!
    @IBOutlet weak var itemOrders: UILabel!
    @IBOutlet weak var itemRating: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    var userImageButtonTapped : (() -> ()) = {}
    var itemDetailButtonTapped : (() -> ()) = {}
    var itemOrderButtonTapped : (() -> ()) = {}
    var itemLikeButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        itemImage.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func userImageButtonPressed(_ sender: Any) {
        userImageButtonTapped()
    }
    
    @IBAction func itemDetailButtonPressed(_ sender: Any) {
        itemDetailButtonTapped()
    }
    
    @IBAction func itemOrderButtonPressed(_ sender: Any) {
        itemOrderButtonTapped()
    }
    
    @IBAction func itemLikeButtonPressed(_ sender: Any) {
        itemLikeButtonTapped()
    }
}
