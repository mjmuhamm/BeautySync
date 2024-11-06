//
//  BeauticianLoginViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/30/24.
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

class BeauticianLoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: MDCOutlinedTextField!
    @IBOutlet weak var password: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: MDCButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.setOutlineColor(UIColor.systemGray4, for: .normal)
        email.setOutlineColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        email.setTextColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        email.setTextColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        
        email.setNormalLabelColor(UIColor.systemGray4, for: .normal)
        email.setFloatingLabelColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        
        password.setOutlineColor(UIColor.lightGray, for: .normal)
        password.setOutlineColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        password.setTextColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        password.setTextColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        
        password.setNormalLabelColor(UIColor.systemGray4, for: .normal)
        password.setFloatingLabelColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .editing)
        
        email.label.text = "Email"
        email.placeholder = "Email"
        
        loginButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        loginButton.layer.cornerRadius = 2
        
        password.label.text = "Password"
        password.placeholder = "Password"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if email.text == nil || email.text == "" || password.text == nil || password.text == "" {
            self.showToast(message: "Please enter your email and password in the alloted fields.", font: .systemFont(ofSize: 12))
        } else {
            
                Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    // ...
                    if error != nil {
                        self!.showToast(message: "An error has occured. \(error!.localizedDescription)", font: .systemFont(ofSize: 12))
                    } else {
                            self!.db.collection("Beautician").document(authResult!.user.uid).collection("PersonalInfo").getDocuments { documents, error in
                                if error == nil {
                                    if documents != nil {
                                        if documents!.documents.count != 0 {
                                            if let vc = self!.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController  {
                                                self!.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    
                                    }
                            }
                        
                        
                    }
                    
                }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if !self.email.text!.isEmpty {
            db.collection("Usernames").getDocuments { documents, error in
                if error == nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        let email = data["email"] as! String
                        let beauticianOrUser = data["beauticianOrUser"] as! String
                        
                        if self.email.text == email {
                            if beauticianOrUser != "Beautician" {
                                self.showToast(message: "It looks like you have a user account. Please create a beautician account to continue.", font: .systemFont(ofSize: 12))
                            } else {
                                Auth.auth().sendPasswordReset(withEmail: email) { error in
                                    if error != nil {
                                        self.showToast(message: "An error has occured. Please try again later.", font: .systemFont(ofSize: 12))
                                    } else {
                                        self.showToast(message: "An email has been sent with instructions to reset your password.", font: .systemFont(ofSize: 12))
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            self.showToast(message: "If you have an account with us, an email has been sent to your email.", font: .systemFont(ofSize: 12))
        } else {
            self.showToast(message: "Please enter your email address in the space above, and try again.", font: .systemFont(ofSize: 12))
        }
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianPersonalInfo") as? BeauticianPersonalViewController {
            
            self.present(vc, animated: true, completion: nil)
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

}
