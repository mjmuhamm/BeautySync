//
//  FilterViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/22/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class FilterViewController: UIViewController {

    let db = Firestore.firestore()
    
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
    
    private var local = 1
    private var region = 0
    private var nation = 0
    private var cityText = ""
    private var stateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadInfo()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func localButtonPressed(_ sender: Any) {
        local = 1
        region = 0
        nation = 0
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
        local = 0
        region = 1
        nation = 0
        city.text = ""
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
        local = 0
        region = 0
        nation = 1
        city.text = ""
        state.text = ""
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
        saveInfo()
    }
    
    
    private func loadInfo() {
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Filter").document(Auth.auth().currentUser!.uid).getDocument { document, error in
            if error == nil {
                if document != nil {
                    let data = document!.data()
                    
                    if let city = data!["city"] as? String, let state = data!["state"] as? String, let local = data!["local"] as? Int, let region = data!["region"] as? Int, let nation = data!["nation"] as? Int {
                        
                        self.local = local
                        self.region = region
                        self.nation = nation
                        self.city.text = city
                        self.state.text = state
                        self.cityText = city
                        self.stateText = state
                        
                        if local == 1 {
                            self.local = 1
                            self.region = 0
                            self.nation = 0
                            self.localButton.setTitleColor(UIColor.white, for: .normal)
                            self.localButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                            self.regionButton.backgroundColor = UIColor.white
                            self.regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.nationButton.backgroundColor = UIColor.white
                            self.nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.city.isHidden = false
                            self.state.isHidden = false
                            self.stateConstraint.constant = 154
                            self.saveConstraint.constant = 72.33
                        } else if region == 1 {
                            self.local = 0
                            self.region = 1
                            self.nation = 0
                            self.city.text = ""
                            self.localButton.backgroundColor = UIColor.white
                            self.localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.regionButton.setTitleColor(UIColor.white, for: .normal)
                            self.regionButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                            self.nationButton.backgroundColor = UIColor.white
                            self.nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.city.isHidden = true
                            self.state.isHidden = false
                            self.stateConstraint.constant = 22
                            self.saveConstraint.constant = 72.33
                        } else {
                            self.local = 0
                            self.region = 0
                            self.nation = 1
                            self.city.text = ""
                            self.state.text = ""
                            self.localButton.backgroundColor = UIColor.white
                            self.localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.regionButton.backgroundColor = UIColor.white
                            self.regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            self.nationButton.setTitleColor(UIColor.white, for: .normal)
                            self.nationButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                            self.city.isHidden = true
                            self.state.isHidden = true
                            self.saveConstraint.constant = 15.33
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    private func saveInfo() {
        var city = ""
        var state = ""
        if self.city.text != "" {
            city = self.city.text!
        }
        
        if self.state.text != "" {
            state = self.state.text!
        }
        
        if local == 1 && (self.city.text == "" || self.state.text == "") {
            self.showToast(message: "Please enter the city and state in the allotted fields.", font: .systemFont(ofSize: 12))
        } else if region == 1 && self.state.text == "" {
            self.showToast(message: "Please enter the state in the allotted field.", font: .systemFont(ofSize: 12))
        } else if (region == 1  || local == 1) && stateFilter(state: self.state.text!) == "not good" {
            self.showToast(message: "Please use the correct state abbreviation.", font: .systemFont(ofSize: 12))
        } else {
            let data : [String: Any] = ["local" : local, "region" : region, "nation" : nation, "city" : city, "state" : state]
            
            db.collection("User").document(Auth.auth().currentUser!.uid).collection("Filter").document(Auth.auth().currentUser!.uid).setData(data)
            
            self.showToastCompletion(message: "Filter Saved.", font: .systemFont(ofSize: 12))
        }
        
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: (self.view.frame.width), height: 70))
        toastLabel.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 4
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    

    func showToastCompletion(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: (self.view.frame.width), height: 70))
        toastLabel.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 4
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
}
