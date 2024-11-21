//
//  UserReviewsViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/21/24.
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

class UserReviewsViewController: UIViewController {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var expectations1: UIImageView!
    @IBOutlet weak var expectations2: UIImageView!
    @IBOutlet weak var expectations3: UIImageView!
    @IBOutlet weak var expectations4: UIImageView!
    @IBOutlet weak var expectations5: UIImageView!
    
    @IBOutlet weak var quality1: UIImageView!
    @IBOutlet weak var quality2: UIImageView!
    @IBOutlet weak var quality3: UIImageView!
    @IBOutlet weak var quality4: UIImageView!
    @IBOutlet weak var quality5: UIImageView!
    
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    
    @IBOutlet weak var recommendYes: MDCButton!
    @IBOutlet weak var recommendNo: MDCButton!
    
    @IBOutlet weak var thoughtsText: UITextField!
    
    private var expectationsNum = 0
    private var qualityNum = 0
    private var beauticianRatingNum = 0
    private var recommend = 1
    
    var item : Orders?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            itemTitle.text = item!.itemTitle
            itemDescription.text = item!.itemDescription
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expectations1ButtonPressed(_ sender: Any) {
        expectationsNum = 1
        self.expectations1.image = UIImage(systemName: "star.fill")
        self.expectations2.image = UIImage(systemName: "star")
        self.expectations3.image = UIImage(systemName: "star")
        self.expectations4.image = UIImage(systemName: "star")
        self.expectations5.image = UIImage(systemName: "star")
    }
    
    @IBAction func expectations2ButtonPressed(_ sender: Any) {
        expectationsNum = 2
        self.expectations1.image = UIImage(systemName: "star.fill")
        self.expectations2.image = UIImage(systemName: "star.fill")
        self.expectations3.image = UIImage(systemName: "star")
        self.expectations4.image = UIImage(systemName: "star")
        self.expectations5.image = UIImage(systemName: "star")
    }
    
    @IBAction func expectations3ButtonPressed(_ sender: Any) {
        expectationsNum = 3
        self.expectations1.image = UIImage(systemName: "star.fill")
        self.expectations2.image = UIImage(systemName: "star.fill")
        self.expectations3.image = UIImage(systemName: "star.fill")
        self.expectations4.image = UIImage(systemName: "star")
        self.expectations5.image = UIImage(systemName: "star")
    }
    
    @IBAction func expectations4ButtonPressed(_ sender: Any) {
        expectationsNum = 4
        self.expectations1.image = UIImage(systemName: "star.fill")
        self.expectations2.image = UIImage(systemName: "star.fill")
        self.expectations3.image = UIImage(systemName: "star.fill")
        self.expectations4.image = UIImage(systemName: "star.fill")
        self.expectations5.image = UIImage(systemName: "star")
    }
    
    @IBAction func expectations5ButtonPressed(_ sender: Any) {
        expectationsNum = 5
        self.expectations1.image = UIImage(systemName: "star.fill")
        self.expectations2.image = UIImage(systemName: "star.fill")
        self.expectations3.image = UIImage(systemName: "star.fill")
        self.expectations4.image = UIImage(systemName: "star.fill")
        self.expectations5.image = UIImage(systemName: "star.fill")
    }
    
    
    @IBAction func quality1ButtonPressed(_ sender: Any) {
        qualityNum = 1
        self.quality1.image = UIImage(systemName: "star.fill")
        self.quality2.image = UIImage(systemName: "star")
        self.quality3.image = UIImage(systemName: "star")
        self.quality4.image = UIImage(systemName: "star")
        self.quality5.image = UIImage(systemName: "star")
    }
    
    @IBAction func quality2ButtonPressed(_ sender: Any) {
        qualityNum = 2
        self.quality1.image = UIImage(systemName: "star.fill")
        self.quality2.image = UIImage(systemName: "star.fill")
        self.quality3.image = UIImage(systemName: "star")
        self.quality4.image = UIImage(systemName: "star")
        self.quality5.image = UIImage(systemName: "star")
    }
    
    @IBAction func quality3ButtonPressed(_ sender: Any) {
        qualityNum = 3
        self.quality1.image = UIImage(systemName: "star.fill")
        self.quality2.image = UIImage(systemName: "star.fill")
        self.quality3.image = UIImage(systemName: "star.fill")
        self.quality4.image = UIImage(systemName: "star")
        self.quality5.image = UIImage(systemName: "star")
    }
    
    @IBAction func quality4ButtonPressed(_ sender: Any) {
        qualityNum = 4
        self.quality1.image = UIImage(systemName: "star.fill")
        self.quality2.image = UIImage(systemName: "star.fill")
        self.quality3.image = UIImage(systemName: "star.fill")
        self.quality4.image = UIImage(systemName: "star.fill")
        self.quality5.image = UIImage(systemName: "star")
    }
    
    @IBAction func quality5ButtonPressed(_ sender: Any) {
        qualityNum = 5
        self.quality1.image = UIImage(systemName: "star.fill")
        self.quality2.image = UIImage(systemName: "star.fill")
        self.quality3.image = UIImage(systemName: "star.fill")
        self.quality4.image = UIImage(systemName: "star.fill")
        self.quality5.image = UIImage(systemName: "star.fill")
    }
    
    
    @IBAction func rating1ButtonPressed(_ sender: Any) {
        beauticianRatingNum = 1
        self.rating1.image = UIImage(systemName: "star.fill")
        self.rating2.image = UIImage(systemName: "star")
        self.rating3.image = UIImage(systemName: "star")
        self.rating4.image = UIImage(systemName: "star")
        self.rating5.image = UIImage(systemName: "star")
    }
    
    @IBAction func rating2ButtonPressed(_ sender: Any) {
        beauticianRatingNum = 2
        self.rating1.image = UIImage(systemName: "star.fill")
        self.rating2.image = UIImage(systemName: "star.fill")
        self.rating3.image = UIImage(systemName: "star")
        self.rating4.image = UIImage(systemName: "star")
        self.rating5.image = UIImage(systemName: "star")
    }
    
    @IBAction func rating3ButtonPressed(_ sender: Any) {
        beauticianRatingNum = 3
        self.rating1.image = UIImage(systemName: "star.fill")
        self.rating2.image = UIImage(systemName: "star.fill")
        self.rating3.image = UIImage(systemName: "star.fill")
        self.rating4.image = UIImage(systemName: "star")
        self.rating5.image = UIImage(systemName: "star")
    }
    
    @IBAction func rating4ButtonPressed(_ sender: Any) {
        beauticianRatingNum = 4
        self.rating1.image = UIImage(systemName: "star.fill")
        self.rating2.image = UIImage(systemName: "star.fill")
        self.rating3.image = UIImage(systemName: "star.fill")
        self.rating4.image = UIImage(systemName: "star.fill")
        self.rating5.image = UIImage(systemName: "star")
    }
    
    @IBAction func rating5ButtonPressed(_ sender: Any) {
        beauticianRatingNum = 5
        self.rating1.image = UIImage(systemName: "star.fill")
        self.rating2.image = UIImage(systemName: "star.fill")
        self.rating3.image = UIImage(systemName: "star.fill")
        self.rating4.image = UIImage(systemName: "star.fill")
        self.rating5.image = UIImage(systemName: "star.fill")
    }
    
    
    @IBAction func recommendYesButtonPressed(_ sender: Any) {
        recommend = 1
        recommendYes.setTitleColor(UIColor.white, for:.normal)
        recommendYes.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        recommendNo.backgroundColor = UIColor.white
        recommendNo.setTitleColor(UIColor(red:98/255, green: 99/255, blue: 72/255, alpha:1), for: .normal)
    }
    
    @IBAction func recommendNoButtonPressed(_ sender: Any) {
        recommend = 0
        recommendYes.backgroundColor = UIColor.white
        recommendYes.setTitleColor(UIColor(red:98/255, green: 99/255, blue: 72/255, alpha:1), for: .normal)
        recommendNo.setTitleColor(UIColor.white, for:.normal)
        recommendNo.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    
}
