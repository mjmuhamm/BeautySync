//
//  UserPersonalViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
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

class UserPersonalViewController: UIViewController {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var localButton: MDCButton!
    @IBOutlet weak var regionButton: MDCButton!
    @IBOutlet weak var nationButton: MDCButton!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var stateConstraint: NSLayoutConstraint!
    //142
    //10
    
    var local = 1
    var region = 0
    var nation = 0
    
    private var newOrEdit = "new"
    private var newBeautician = ""
    private var profilePic = ""
    private var documentId = ""
    
    private var userImage1 : UIImage?
    private var userImageData : Data?
    
    @IBOutlet weak var saveButtonConstraint: NSLayoutConstraint!
    //68
    //27
    @IBOutlet weak var saveButton: MDCButton!
    
    
    @IBOutlet weak var usernameChangeButton: UIButton!
    @IBOutlet weak var emailChangeButton: UIButton!
    @IBOutlet weak var passwordChangeButton: UIButton!
    
    var originalUsername = ""
    var originalEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newOrEdit == "edit" {
            usernameChangeButton.isHidden = false
            emailChangeButton.isHidden = false
            passwordChangeButton.isHidden = false
            userName.isEnabled = false
            email.isEnabled = false
            password.isEnabled = false
            confirmPassword.isEnabled = false
            loadInfo()
            
        } else {
            usernameChangeButton.isHidden = true
            emailChangeButton.isHidden = true
            passwordChangeButton.isHidden = true
            userName.isEnabled = true
            email.isEnabled = true
            password.isEnabled = true
            confirmPassword.isEnabled = true
        }

        
    }
    
    private func loadInfo() {
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
            if error == nil {
                if documents?.documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let fullName = data["fullName"] as? String, let userName = data["userName"] as? String, let email = data["email"] as? String, let local = data["local"] as? Int, let region = data["region"] as? Int, let nation = data["nation"] as? Int, let city = data["city"] as? String, let state = data["state"] as? String {
                            self.fullName.text = fullName
                            self.email.text = email
                            self.originalEmail = email
                            self.userName.text = userName
                            self.originalUsername = userName
                            self.password.text = "********"
                            self.confirmPassword.text = "********"
                            self.city.text = city
                            self.state.text = state
                            self.local = local
                            self.region = region
                            self.nation = nation
                            self.documentId = doc.documentID
                            
                            if local == 1 {
                                self.localButton.setTitleColor(UIColor.white, for: .normal)
                                self.localButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                                self.regionButton.backgroundColor = UIColor.white
                                self.regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                self.nationButton.backgroundColor = UIColor.white
                                self.nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                
                                self.city.isHidden = false
                                self.state.isHidden = false
                                self.stateConstraint.constant = 142
                                self.saveButtonConstraint.constant = 68
                            }
                            if region == 1 {
                                self.localButton.backgroundColor = UIColor.white
                                self.localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                self.regionButton.setTitleColor(UIColor.white, for: .normal)
                                self.regionButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                                self.nationButton.backgroundColor = UIColor.white
                                self.nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                
                                self.city.isHidden = true
                                self.state.isHidden = false
                                self.stateConstraint.constant = 10
                                self.saveButtonConstraint.constant = 67
                            }
                            
                            if nation == 1 {
                                self.localButton.backgroundColor = UIColor.white
                                self.localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                self.regionButton.backgroundColor = UIColor.white
                                self.regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
                                self.nationButton.setTitleColor(UIColor.white, for: .normal)
                                self.nationButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
                                
                                self.city.isHidden = true
                                self.state.isHidden = true
                                self.saveButtonConstraint.constant = 27
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userImageButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (handler) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let image = UIImagePickerController()
                image.allowsEditing = true
                image.sourceType = .camera
                image.delegate = self
//                image.mediaTypes = [UTType.image.identifier]
                self.present(image, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let image = UIImagePickerController()
                image.allowsEditing = true
                image.delegate = self
                self.present(image, animated: true, completion: nil)
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func usernameChangeButtonPressed(_ sender: Any) {
        userName.isEnabled = true
    }
    
    @IBAction func emailChangeButtonPressed(_ sender: Any) {
        email.isEnabled = true
    }
    
    @IBAction func passwordChangeButtonPressed(_ sender: Any) {
        password.isEnabled = true
        confirmPassword.isEnabled = true
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
        stateConstraint.constant = 142
        saveButtonConstraint.constant = 68
        
    }
    
    @IBAction func regionButtonPressed(_ sender: Any) {
        local = 0
        region = 1
        nation = 0
        
        localButton.backgroundColor = UIColor.white
        localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        regionButton.setTitleColor(UIColor.white, for: .normal)
        regionButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        nationButton.backgroundColor = UIColor.white
        nationButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        
        city.isHidden = true
        state.isHidden = false
        stateConstraint.constant = 10
        saveButtonConstraint.constant = 67
    }
    
    @IBAction func nationButtonPressed(_ sender: Any) {
        local = 0
        region = 0
        nation = 1
        
        localButton.backgroundColor = UIColor.white
        localButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        regionButton.backgroundColor = UIColor.white
        regionButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nationButton.setTitleColor(UIColor.white, for: .normal)
        nationButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        
        city.isHidden = true
        state.isHidden = true
        saveButtonConstraint.constant = 27
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
            if fullName.text == "" {
                self.showToast(message: "Please enter your full name in the alloted field.", font: .systemFont(ofSize: 12))
            } else if userName.text == "" || "\(userName.text!)".contains(" ") == true || searchForSpecialChar(search: userName.text!) == true || userName.text!.count < 4 {
                self.showToast(message: "Please enter a username with no spaces, no special characters, and longer than 3 characters in the alloted field.", font: .systemFont(ofSize: 12))
            } else if self.email.text == "" || !isValidEmail(self.email.text!) {
                self.showToast(message: "Please enter your valid email address.", font: .systemFont(ofSize: 12))
            } else if local == 1 && (city.text == "" || state.text == "") {
                self.showToast(message: "Please enter your city and the abbreviation for your state", font: .systemFont(ofSize: 12))
            } else if region == 1 && state.text == "" {
                self.showToast(message: "Please enter the abbreviation for your state.", font: .systemFont(ofSize: 12))
            } else {
                
                if newOrEdit == "new" {
                    if password.text == "" || password.text! != self.confirmPassword.text! || !isPasswordValid(password: password.text!) {
                        self.showToast(message: "Please make sure your password has 1 uppercase letter, 1 special character, 1 number, 1 lowercase letter, and is atleast 8 characters long.", font: .systemFont(ofSize: 12))
                    } else {
                        let storageRef = storage.reference()
                        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                            
                            if error == nil {
                                if self.userImage1 != nil {
                                    if self.userImageData != nil {
                                        self.profilePic = "yes"
                                        
                                        storageRef.child("users/\(self.email.text!)/profileImage/\(authResult!.user.uid).png").putData(self.userImageData!)
                                        
                                        if self.userImageData == nil {
                                            self.profilePic = "no"
                                            let image = UIImage(named: "default_image")!.pngData()
                                            storageRef.child("users/\(self.email.text!)/profileImage/\(authResult!.user.uid).png").putData(image!)
                                        }
                                    }}
                                        
                                        let data: [String: Any] = ["fullName" : self.fullName.text!, "userName" : self.userName.text!, "email" : self.email.text!, "local" : self.local, "region" : self.region, "nation" : self.nation, "city": self.city.text!, "state" : self.state.text!, "beauticianOrUser" : "User"]
                                        let data1: [String: Any] = ["userName" : self.userName.text!, "email": self.email.text!, "beauticianOrUser" : "User", "fullName" : self.fullName.text!]
                                        let data2: [String: Any] = ["beauticianOrUser" : "User", "privatizeData" : "no", "notificationToken" : "", "profilePic" : self.profilePic]
                                        
                                        self.db.collection("User").document(authResult!.user.uid).collection("PersonalInfo").document().setData(data)
                                        self.db.collection("Usernames").document(authResult!.user.uid).setData(data1)
                                        self.db.collection("User").document(authResult!.user.uid).setData(data2)
                                        
                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = "User"
                                        changeRequest?.commitChanges()
                                        
                                        self.showToastCompletion(message: "Profile Updated.", font: .systemFont(ofSize: 12))
                                    }
                                }
                    }
                } else {
                    if originalEmail != email.text {
                        if !isValidEmail(self.email!.text!) {
                            self.showToast(message: "Please enter your valid email address.", font: .systemFont(ofSize: 12))
                        } else {
                            Auth.auth().currentUser?.email = self.email.text!
                            let data: [String: Any] = ["email" : self.email.text!]
                            self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").document(self.documentId).updateData(data)
                            self.db.collection("Usernames").document(Auth.auth().currentUser!.uid).updateData(data)
                            self.showToast(message: "Email Updated.", font: .systemFont(ofSize: 12))
                        }
                    }
                    if originalUsername != self.userName.text {
                        let data : [String : Any] = ["userName" : self.userName.text!]
                        self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").document(self.documentId).updateData(data)
                        self.db.collection("Usernames").document(Auth.auth().currentUser!.uid).updateData(data)
                        self.showToast(message: "Username Updated", font: .systemFont(ofSize: 12))
                    }
                    if self.password.text != "" && self.password.isEnabled == true {
                        if self.password.text! != self.confirmPassword.text! {
                            self.showToast(message: "Please make sure your password matches in the confirm password field.", font: .systemFont(ofSize: 12))
                        } else if !isPasswordValid(password: self.password.text!) {
                            self.showToast(message: "Please make sure password has 1 uppercase letter, 1 special character, 1 number, 1 lowercase letter, and matches with the second insert.", font: .systemFont(ofSize: 12))
                        } else {
                            Auth.auth().currentUser?.updatePassword(to: self.password.text!)
                            self.showToast(message: "Password Updated.", font: .systemFont(ofSize: 12))
                           
                        }
                    }
                    let data : [String: Any] = ["local" : self.local, "region" : self.region, "nation" : self.nation, "city": self.city.text!, "state" : self.state.text!]
                    self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").document(self.documentId).updateData(data)
                    self.showToast(message: "Location Preference Updated.", font: .systemFont(ofSize: 12))
                   
                    
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
   
    
   

}

extension UserPersonalViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.userImage.image = image
        self.userImage1 = image
        if newOrEdit == "edit" {
            let data : [String: Any] = ["profilePic" : "yes"]
            let storageRef = storage.reference()
            db.collection("User").document(Auth.auth().currentUser!.uid).updateData(data)
            storageRef.child("users/\(Auth.auth().currentUser!.email!)/profileImage/\(Auth.auth().currentUser!.uid).png").putData(image.pngData()!)
            self.showToast(message: "Image Updated.", font: .systemFont(ofSize: 12))
        }
        self.userImageData = image.pngData()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
