//
//  AddPersonViewController.swift
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

class AddPersonViewController: UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var executiveYesButton: MDCButton!
    @IBOutlet weak var executiveNoButton: MDCButton!
    
    @IBOutlet weak var ownerYesButton: MDCButton!
    
    @IBOutlet weak var ownerNoButton: MDCButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var taxId: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var businessBankingInfo: BusinessBankingInfo?
    
    var newOrEdit = ""
    var newPersonOrEditPerson = ""
    var typeOfPerson = ""
    
    var isPersonAnExecutive = "yes"
    var isPersonAnOwner = "yes"
    
    var person : Person?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if newPersonOrEditPerson == "edit" {
            loadInfo()
        }
        if typeOfPerson != "" {
            if businessBankingInfo != nil {
                if businessBankingInfo!.owners != nil {
                    if typeOfPerson.prefix(5) == "owner" {
                        deleteButton.isHidden = false
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func loadInfo() {
        
        if typeOfPerson == "owner1" {
            if businessBankingInfo != nil {
                if businessBankingInfo!.owners != nil {
                    if businessBankingInfo!.owners!.count > 0 {
                        person = businessBankingInfo!.owners![0]
                    }
                }
            }
            
        } else if typeOfPerson == "owner2" {
            if businessBankingInfo != nil {
                if businessBankingInfo!.owners != nil {
                    if businessBankingInfo!.owners!.count > 1 {
                        person = businessBankingInfo!.owners![1]
                    }
                }
            }
        } else if typeOfPerson == "owner3" {
            if businessBankingInfo != nil {
                if businessBankingInfo!.owners != nil {
                    if businessBankingInfo!.owners!.count > 2 {
                        person = businessBankingInfo!.owners![2]
                    }
                }
            }
        } else if typeOfPerson == "owner4" {
            if businessBankingInfo != nil {
                if businessBankingInfo!.owners != nil {
                    if businessBankingInfo!.owners!.count > 3 {
                        person = businessBankingInfo!.owners![3]
                    }
                }
            }
        }
        if person != nil {
            if person!.isPersonAnExectutive == "yes" {
                executiveYesButton.setTitleColor(UIColor.white, for: .normal)
                executiveYesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                executiveNoButton.backgroundColor = UIColor.white
                executiveNoButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            } else {
                executiveYesButton.backgroundColor = UIColor.white
                executiveYesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                executiveNoButton.setTitleColor(UIColor.white, for: .normal)
                executiveNoButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
            }
            
            if person!.isPersonAnOwner == "yes" {
                ownerYesButton.setTitleColor(UIColor.white, for: .normal)
                ownerYesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                ownerNoButton.backgroundColor = UIColor.white
                ownerNoButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            } else {
                ownerYesButton.backgroundColor = UIColor.white
                ownerYesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                ownerNoButton.setTitleColor(UIColor.white, for: .normal)
                ownerNoButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
            }
            self.firstName.text = person!.firstName
            self.lastName.text = person!.lastName
            self.month.text = person!.month
            self.day.text = person!.day
            self.year.text = person!.year
            self.streetAddress.text = person!.streetAddress
            self.city.text = person!.city
            self.state.text = person!.state
            self.zipCode.text = person!.zipCode
            self.email.text = person!.emailAddress
            self.phone.text = person!.phoneNumber
            self.taxId.text = person!.taxId
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        var stripeId = ""
        var personId = ""
        if person != nil {
            stripeId = person!.stripeAccountId
            personId = person!.personId
        }
        let alert = UIAlertController(title: "Are you sure you want to delete this person from your owners' list?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            self.deletePerson(stripeId: stripeId, personId: personId)
//            self.businessBankingInfo
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Owners") as? OwnersViewController {
                
                self.present(vc, animated: true, completion: nil)
            }
                    
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func executiveYesButtonPressed(_ sender: Any) {
        isPersonAnExecutive = "yes"
        executiveYesButton.setTitleColor(UIColor.white, for: .normal)
        executiveYesButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        executiveNoButton.backgroundColor = UIColor.white
        executiveNoButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func executiveNoButtonPressed(_ sender: Any) {
        isPersonAnExecutive = "no"
        executiveYesButton.backgroundColor = UIColor.white
        executiveYesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        executiveNoButton.setTitleColor(UIColor.white, for: .normal)
        executiveNoButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        
    }
    
    @IBAction func ownerYesButtonPressed(_ sender: Any) {
        isPersonAnOwner = "yes"
        executiveYesButton.setTitleColor(UIColor.white, for: .normal)
        executiveYesButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        executiveNoButton.backgroundColor = UIColor.white
        executiveNoButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func ownerNoButtonPressed(_ sender: Any) {
        isPersonAnOwner = "no"
        executiveYesButton.backgroundColor = UIColor.white
        executiveYesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        executiveNoButton.setTitleColor(UIColor.white, for: .normal)
        executiveNoButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if firstName.text == "" || lastName.text == "" {
            self.showToast(message: "Please enter the name of this person in the alloted fields.", font: .systemFont(ofSize: 12))
        } else if month.text == "" || day.text == "" || year.text == "" {
            self.showToast(message: "Please enter the date of birth of this person in the alloted fields.", font: .systemFont(ofSize: 12))
        } else if streetAddress.text == "" || city.text == "" || state.text == "" || zipCode.text == "" {
            self.showToast(message: "Please enter the street address of this person in the alloted fields.", font: .systemFont(ofSize: 12))
        } else if email.text == "" {
            self.showToast(message: "Please enter the email address of this person in the alloted field.", font: .systemFont(ofSize: 12))
        } else if phone.text == "" {
            self.showToast(message: "Please enter the phone number of this person in the alloted field.", font: .systemFont(ofSize: 12))
        } else if taxId.text == "" || taxId.text!.count != 9 {
            self.showToast(message: "Please enter the taxId of this person in the alloted field.", font: .systemFont(ofSize: 12))
        }
    }
    
    
    
    private func deletePerson(stripeId: String, personId: String) {
        let json : [String:Any] = ["stripeAccountId" : "\(stripeId)", "personId" : "\(personId)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/delete-person")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  
                  
                let self = self else {
            // Handle error
            return
            }
            
            DispatchQueue.main.async {
//                if representativeOrOwner == "representative" {
//                    let data : [String: Any] = ["representativeId" : ""]
//                    
//                }
            }
        })
        task.resume()
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
    

}
