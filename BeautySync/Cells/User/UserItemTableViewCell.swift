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
    
    @IBOutlet weak var itemLikes: UILabel!
    @IBOutlet weak var itemOrders: UILabel!
    @IBOutlet weak var itemRating: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    var userImageButtonTapped : (() -> ()) = {}
    var itemImageButtonTapped : (() -> ()) = {}
    var itemOrderButtonTapped : (() -> ()) = {}
    
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
    
    @IBAction func itemDetailButtonPressed(_ sender: Any) {
        itemImageButtonTapped()
    }
    
    @IBAction func itemOrderButtonPressed(_ sender: Any) {
        itemOrderButtonTapped()
    }
    
}
