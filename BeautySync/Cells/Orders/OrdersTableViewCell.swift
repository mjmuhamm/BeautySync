//
//  OrdersTableViewCell.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/13/24.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notesToBeautician: UILabel!
    
    @IBOutlet weak var messagesForSchedulingButton: MDCButton!
    @IBOutlet weak var cancelButton: MDCButton!
    @IBOutlet weak var messagesButton: MDCButton!
    
    @IBOutlet weak var takeHome: UILabel!
    //62
    //19
    @IBOutlet weak var cancelButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messagesButtonConstraint: NSLayoutConstraint!
    
    
    var messagesForSchedulingButtonTapped : (() -> ()) = {}
    var cancelButtonTapped : (() -> ()) = {}
    var messagesButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messagesForSchedulingButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        messagesButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        cancelButton.applyOutlinedTheme(withScheme: secondGlobalContainerScheme())
        cancelButton.layer.cornerRadius = 5
        messagesButton.layer.cornerRadius = 5
        messagesForSchedulingButton.layer.cornerRadius = 5
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messagesForSchedulingButtonPressed(_ sender: Any) {
        messagesForSchedulingButtonTapped()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelButtonTapped()
    }
    
    @IBAction func messagesButtonPressed(_ sender: Any) {
        messagesButtonTapped()
    }
}
