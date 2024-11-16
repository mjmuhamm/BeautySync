//
//  MessagesTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/16/24.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var awayUserImage: UIImageView!
    @IBOutlet weak var awayMessage: UILabel!
    @IBOutlet weak var awayDate: UILabel!
    
    @IBOutlet weak var homeUserImage: UIImageView!
    @IBOutlet weak var homeMessage: UILabel!
    @IBOutlet weak var homeDate: UILabel!
    
    @IBOutlet weak var togetherMessage: UILabel!
    
    
    var awayUserImageButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func awayUserImageButtonPressed(_ sender: Any) {
        awayUserImageButtonTapped()
    }
    
    @IBAction func homeUserImageButtonPressed(_ sender: Any) {
    }
    
    
}
