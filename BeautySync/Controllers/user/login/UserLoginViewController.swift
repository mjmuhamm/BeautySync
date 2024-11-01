//
//  UserLoginViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/30/24.
//

import UIKit
import FirebaseAuth
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class UserLoginViewController: UIViewController {
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
    }


}
