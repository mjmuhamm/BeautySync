//
//  ViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/30/24.
//

import UIKit
import Firebase
import FirebaseAuth
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming


class StartViewController: UIViewController {

    @IBOutlet weak var userButton: MDCButton!
    
    @IBOutlet weak var beauticianButton: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        beauticianButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        userButton.layer.cornerRadius = 2
        beauticianButton.layer.cornerRadius = 2
    }
    
    @IBAction func userButtonPressed (_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserLogin") as? UserLoginViewController {
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func beauticianButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianLogin") as? BeauticianLoginViewController {
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func termsOfServiceButtonPressed(_ sender: Any) {
    }
    

    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
    }
    
    
    
}


func globalContainerScheme() -> MDCContainerScheming {
  let containerScheme = MDCContainerScheme()
  // Customize containerScheme here...
    let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
    colorScheme.primaryColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
    colorScheme.secondaryColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    containerScheme.colorScheme = colorScheme
    
  return containerScheme
}

func secondGlobalContainerScheme() -> MDCContainerScheming {
  let containerScheme = MDCContainerScheme()
  // Customize containerScheme here...
    let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
    colorScheme.primaryColor = UIColor.red
    colorScheme.secondaryColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    containerScheme.colorScheme = colorScheme
    
  return containerScheme
}

func searchForSpecialChar(search: String) -> Bool {
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    if search.rangeOfCharacter(from: characterset.inverted) != nil {
        print("string contains special characters")
        return true
    }
    return false
}

func stateFilter(state: String) -> String {
    
    var stateAbbr : [String] = ["AL", "AK", "AZ", "AR", "AS", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "TT", "UT", "VT", "VA", "VI", "WA", "WY", "WV", "WI", "WY" ]
    
    for i in 0..<stateAbbr.count {
        let a = stateAbbr[i].lowercased()
        if a == state.lowercased() {
            return "good"
        }
    }
    
    return "not good"
  
    
}