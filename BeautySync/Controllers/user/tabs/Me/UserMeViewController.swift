//
//  UserMeViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/9/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class UserMeViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationBell: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var whatUserIsLookingFor: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var ordersButton: MDCButton!
    @IBOutlet weak var beauticiansButton: MDCButton!
    @IBOutlet weak var likesButton: MDCButton!
    @IBOutlet weak var reviewsButton: MDCButton!
    
    @IBOutlet weak var userTableView: UITableView!
    
    var itemType = "orders"
    var items : [ServiceItems] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func notificationButtonPressed(_ sender: Any) {
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountSettings") as? UserAccountSettingsViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
        itemType = "orders"
        ordersButton.setTitleColor(UIColor.white, for: .normal)
        ordersButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func beauticiansButtonPressed(_ sender: Any) {
        itemType = "beauticians"
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.setTitleColor(UIColor.white, for: .normal)
        beauticiansButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func likesButtonPressed(_ sender: Any) {
        itemType = "likes"
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.setTitleColor(UIColor.white, for: .normal)
        likesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func reviewsButtonPressed(_ sender: Any) {
        itemType = "reviews"
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.setTitleColor(UIColor.white, for: .normal)
        reviewsButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
}
