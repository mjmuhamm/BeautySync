//
//  BusinessViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class BeauticianBusinessViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var education: UITextField!
    @IBOutlet weak var passion: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    
    @IBOutlet weak var yesButton: MDCButton!
    @IBOutlet weak var noButton: MDCButton!
    
    private var yes = 1
    private var no = 0
    
    private var newOrEdit = "new"
    private var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if newOrEdit == "edit" {
            loadInfo()
        }
        
    }
    
    private func loadInfo() {
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
            if error == nil {
                if documents?.documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let education = data["education"] as? String, let passion = data["passion"] as? String, let streetAddress = data["streetAddress"] as? String, let city = data["city"] as? String, let state = data["state"] as? String, let zipCode = data["zipCode"] as? String, let openToTravel = data["openToTravel"] as? Int {
                            
                            self.education.text = education
                            self.passion.text = passion
                            self.streetAddress.text = streetAddress
                            self.city.text = city
                            self.state.text = state
                            self.zipCode.text = zipCode
                            self.documentId = doc.documentID
                            
                            if openToTravel == 1 {
                                self.yes = 1
                                self.no = 0
                                
                                self.yesButton.setTitleColor(UIColor.white, for: .normal)
                                self.yesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                                self.noButton.backgroundColor = UIColor.white
                                self.noButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                            } else {
                                self.yes = 0
                                self.no = 1
                                
                                self.yesButton.backgroundColor = UIColor.white
                                self.yesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                self.noButton.setTitleColor(UIColor.white, for: .normal)
                                self.noButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        yes = 1
        no = 0
        
        yesButton.setTitleColor(UIColor.white, for: .normal)
        yesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        noButton.backgroundColor = UIColor.white
        noButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        yes = 0
        no = 1
        
        yesButton.backgroundColor = UIColor.white
        yesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        noButton.setTitleColor(UIColor.white, for: .normal)
        noButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
       
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if education.text == "" {
            self.showToast(message: "Please enter your education in the alloted field.", font: .systemFont(ofSize: 12))
        } else if streetAddress.text == "" || city.text == "" || state.text == "" || zipCode.text == "" {
            self.showToast(message: "Please enter your complete business address in the alloted fields.", font: .systemFont(ofSize: 12))
        } else {
            var x = ""
            if self.passion.text != nil {
                x = self.passion.text!
            }
            var y = 0
            if self.yes == 0 { y = 0 } else { y = 1 }
            let data : [String: Any] = ["education" : self.education.text!,  "passion" : x, "streetAddress" : self.streetAddress.text!, "city" : self.city.text!, "state" : self.state.text!, "zipCode" : self.zipCode.text!, "openToTravel" : y]
            
            if newOrEdit == "new" {
                self.db.collection("Beauticians").document(Auth.auth().currentUser!.uid).collection("BusinessInfo").document(self.documentId).setData(data)
                self.showToastCompletion(message: "Business Info Updated.", font: .systemFont(ofSize: 12))
            } else {
                self.db.collection("Beauticians").document(Auth.auth().currentUser!.uid).collection("BusinessInfo").document(self.documentId).updateData(data)
                self.showToastCompletion2(message: "Business Info Updated.", font: .systemFont(ofSize: 12))
            }
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
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
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
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianBankingInfo") as? BeauticianBankingViewController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastCompletion2(message : String, font: UIFont) {
        
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
    

}
