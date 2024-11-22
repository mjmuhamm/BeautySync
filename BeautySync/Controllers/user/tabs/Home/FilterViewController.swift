//
//  FilterViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/22/24.
//

import UIKit

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class FilterViewController: UIViewController {

    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var localButton: MDCButton!
    @IBOutlet weak var regionButton: MDCButton!
    @IBOutlet weak var nationButton: MDCButton!
    
    //154
    //22
    @IBOutlet weak var stateConstraint: NSLayoutConstraint!
    
    //72.33
    //15.33
    @IBOutlet weak var saveConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func localButtonPressed(_ sender: Any) {
        localButton.setTitleColor(UIColor.white, for: .normal)
        localButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        regionButton.backgroundColor = UIColor.white
        regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nationButton.backgroundColor = UIColor.white
        nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        
        city.isHidden = false
        state.isHidden = false
        stateConstraint.constant = 154
        saveConstraint.constant = 72.33
    }
    
    @IBAction func regionButtonPressed(_ sender: Any) {
        localButton.backgroundColor = UIColor.white
        localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        regionButton.setTitleColor(UIColor.white, for: .normal)
        regionButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        nationButton.backgroundColor = UIColor.white
        nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        
        city.isHidden = true
        state.isHidden = false
        stateConstraint.constant = 22
        saveConstraint.constant = 72.33
    }
    
    @IBAction func nationButtonPressed(_ sender: Any) {
        localButton.backgroundColor = UIColor.white
        localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        regionButton.backgroundColor = UIColor.white
        regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nationButton.setTitleColor(UIColor.white, for: .normal)
        nationButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        city.isHidden = true
        state.isHidden = true
        saveConstraint.constant = 15.33
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    

}
