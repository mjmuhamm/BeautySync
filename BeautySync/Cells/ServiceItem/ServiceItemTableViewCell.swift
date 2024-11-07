//
//  ServiceItemTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/7/24.
//

import UIKit

class ServiceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemEditButton: UIButton!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemOrderButton: UIButton!
    
    @IBOutlet weak var itemLikeImage: UIImageView!
    @IBOutlet weak var itemLikes: UILabel!
    @IBOutlet weak var itemOrders: UILabel!
    @IBOutlet weak var itemRating: UILabel!
    
    var itemLikeButtonTapped : (() -> ()) = {}
    var orderButtonTapped : (() -> ()) = {}
    var itemDetailButtonTapped : (() -> ()) = {}
    
    
    
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
    
    @IBAction func itemLikeButtonPressed(_ sender: Any) {
        itemLikeButtonTapped()
        
    }
    
    @IBAction func itemDetailButtonPressed(_ sender: Any) {
        itemDetailButtonTapped()
    }
}
