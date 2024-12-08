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
        
        awayUserImage.layer.borderWidth = 1
        awayUserImage.layer.masksToBounds = false
        awayUserImage.layer.borderColor = UIColor.white.cgColor
        awayUserImage.layer.cornerRadius = awayUserImage.frame.height/2
        awayUserImage.clipsToBounds = true
        
        homeUserImage.layer.borderWidth = 1
        homeUserImage.layer.masksToBounds = false
        homeUserImage.layer.borderColor = UIColor.white.cgColor
        homeUserImage.layer.cornerRadius = homeUserImage.frame.height/2
        homeUserImage.clipsToBounds = true
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
