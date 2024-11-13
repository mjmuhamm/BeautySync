//
//  PersonalViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class BeauticianPersonalViewController: UIViewController {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var usernameChangeButton: UIButton!
    @IBOutlet weak var emailChangeButton: UIButton!
    @IBOutlet weak var passwordChangeButton: UIButton!
    
    private var newOrEdit = "new"
    
    private var profilePic = ""
    private var userImage1 : UIImage?
    private var userImageData : Data?
    
    private var documentId = ""
    private var originalEmail = ""
    private var originalUsername = ""
    
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
        if Auth.auth().currentUser != nil {
            db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
                if error == nil {
                    if documents != nil {
                        for doc in documents!.documents {
                            let data = doc.data()
                            if let fullName = data["fullName"] as? String, let userName = data["userName"] as? String, let email = data["email"] as? String {
                                self.fullName.text = fullName
                                self.userName.text = userName
                                self.email.text = email
                                
                                self.userName.isEnabled = false
                                self.email.isEnabled = false
                                self.usernameChangeButton.isHidden = false
                                self.emailChangeButton.isHidden = false
                                self.passwordChangeButton.isHidden = false
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
    
    @IBAction func userNameChangeButtonPressed(_ sender: Any) {
        userName.isEnabled = true
    }
    
    @IBAction func emailChangeButtonPressed(_ sender: Any) {
        email.isEnabled = true
    }
    
    @IBAction func passwordChangeButtonPressed(_ sender: Any) {
        password.isEnabled = true
        confirmPassword.isEnabled = true
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if fullName.text == "" {
            self.showToast(message: "Please enter your full name in the alloted field.", font: .systemFont(ofSize: 12))
        } else if userName.text == "" || "\(userName.text!)".contains(" ") == true || searchForSpecialChar(search: userName.text!) == true || userName.text!.count < 4 {
            self.showToast(message: "Please enter a username with no spaces, no special characters, and longer than 3 characters in the alloted field.", font: .systemFont(ofSize: 12))
        } else if self.email.text == "" || !isValidEmail(self.email.text!) {
            self.showToast(message: "Please enter your valid email address.", font: .systemFont(ofSize: 12))
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
                                    
                                    storageRef.child("beauticians/\(authResult!.user.uid)/profileImage/\(authResult!.user.uid).png").putData(self.userImageData!)
                                    
                                }
                                } 
                                    
                                    let data: [String: Any] = ["fullName" : self.fullName.text!, "userName" : self.userName.text!, "email" : self.email.text!, "beauticianOrUser" : "Beautician"]
                                    let data1: [String: Any] = ["userName" : self.userName.text!, "email": self.email.text!, "beauticianOrUser" : "Beautician", "fullName" : self.fullName.text!]
                                    let data2: [String: Any] = ["beauticianOrUser" : "Beautician", "privatizeData" : "no", "notificationToken" : "", "profilePic" : self.profilePic]
                                    
                                    self.db.collection("Beautician").document(authResult!.user.uid).collection("PersonalInfo").document().setData(data)
                                    self.db.collection("Usernames").document(authResult!.user.uid).setData(data1)
                                    self.db.collection("Beautician").document(authResult!.user.uid).setData(data2)
                                    
                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changeRequest?.displayName = "Beautician"
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
                        Auth.auth().currentUser!.sendEmailVerification(beforeUpdatingEmail: self.email.text!)
                        
                        self.showToast(message: "An email verification has been sent to the entered email.", font: .systemFont(ofSize: 12))
                        let data: [String: Any] = ["email" : self.email.text!]
                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").document(self.documentId).updateData(data)
                        self.db.collection("Usernames").document(Auth.auth().currentUser!.uid).updateData(data)
                        self.showToast(message: "Email Updated.", font: .systemFont(ofSize: 12))
                    }
                }
                if originalUsername != self.userName.text {
                    let data : [String : Any] = ["userName" : self.userName.text!]
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").document(self.documentId).updateData(data)
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianBusinessInfo") as? BeauticianBusinessViewController {
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

extension BeauticianPersonalViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
            db.collection("Beautician").document(Auth.auth().currentUser!.uid).updateData(data)
            storageRef.child("beauticians/\(Auth.auth().currentUser!.uid)/profileImage/\(Auth.auth().currentUser!.uid).png").putData(image.pngData()!)
            self.showToast(message: "Image Updated.", font: .systemFont(ofSize: 12))
        }
        self.userImageData = image.pngData()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
