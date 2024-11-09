//
//  HomeTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/8/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemLikeImage: UIImageView!
    @IBOutlet weak var itemLikes: UILabel!
    @IBOutlet weak var itemOrders: UILabel!
    @IBOutlet weak var itemRating: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    var orderButtonTapped : (() -> ()) = {}
    var itemDetailButtonTapped : (() -> ()) = {}
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
    
    @IBAction func itemOrderButtonPressed(_ sender: Any) {
        orderButtonTapped()
    }
    
    @IBAction func itemDetailButtonPressed(_ sender: Any) {
        itemDetailButtonTapped()
    }
    
    @IBAction func userImageButtonPressed(_ sender: Any) {
        userImageButtonTapped()
    }
    
    @IBAction func userLikeButtonPressed(_ sender: Any) {
        userLikeButtonTapped()
    }
    
}
