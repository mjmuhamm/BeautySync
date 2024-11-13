//
//  CheckoutTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/12/24.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var serviceCost: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var noteToBeautician: UILabel!
    
    var cancelButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelButtonTapped()
    }
    
    
}
