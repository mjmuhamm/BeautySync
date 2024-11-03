//
//  AccountViewController.swift
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

class BeauticianBankingViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var skipForNowButton: UIButton!
    @IBOutlet weak var individualView: UIView!
    @IBOutlet weak var businessView: UIView!
    
    @IBOutlet weak var individualButton: MDCButton!
    @IBOutlet weak var businessButton: MDCButton!
    
    //Individual
    @IBOutlet weak var iAcceptButton: UIButton!
    @IBOutlet weak var iAcceptCircle: UIImageView!
    @IBOutlet weak var iMccCode: UITextField!
    @IBOutlet weak var iBusinessUrl: UITextField!
    @IBOutlet weak var iFirstName: UITextField!
    @IBOutlet weak var iLastName: UITextField!
    @IBOutlet weak var iMonth: UITextField!
    @IBOutlet weak var iDay: UITextField!
    @IBOutlet weak var iYear: UITextField!
    @IBOutlet weak var iPhoneNumber: UITextField!
    @IBOutlet weak var iEmail: UITextField!
    @IBOutlet weak var iStreetAddress: UITextField!
    @IBOutlet weak var iCity: UITextField!
    @IBOutlet weak var iState: UITextField!
    @IBOutlet weak var iZipCode: UITextField!
    @IBOutlet weak var iLast4Ssn: UITextField!
    @IBOutlet weak var iExternalAccountLabel: UILabel!
    @IBOutlet weak var iSaveButton: UIButton!
    
    //Business
    @IBOutlet weak var bAcceptButton: UIButton!
    @IBOutlet weak var bAcceptCircle: UIImageView!
    @IBOutlet weak var bMccCode: UITextField!
    @IBOutlet weak var bBusinessUrl: UITextField!
    @IBOutlet weak var bCompanyName: UITextField!
    @IBOutlet weak var bCompanyStreetAddress: UITextField!
    @IBOutlet weak var bCompanyCity: UITextField!
    @IBOutlet weak var bCompanyState: UITextField!
    @IBOutlet weak var bCompanyZipCode: UITextField!
    @IBOutlet weak var bCompanyPhone: UITextField!
    @IBOutlet weak var bCompanyTaxId: UITextField!
    @IBOutlet weak var bExternalAccountLabel: UILabel!
    @IBOutlet weak var bRepresentativeLabel: UILabel!
    @IBOutlet weak var bSaveButton: UIButton!
    
    var newOrEdit = "new"
    var individualBankingInfo : IndividualBankingInfo?
    var businessBankingInfo : BusinessBankingInfo?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshNewAccountInfo()
    }
    
    private func refreshNewAccountInfo() {
        if individualBankingInfo != nil {
            
            self.individualView.isHidden = false
            self.businessView.isHidden = true
            individualButton.setTitleColor(UIColor.white, for: .normal)
            individualButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
            businessButton.backgroundColor = UIColor.white
            businessButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            
            self.iMccCode.text = self.individualBankingInfo!.mccCode
            self.iBusinessUrl.text = self.individualBankingInfo!.businessUrl
            self.iFirstName.text = self.individualBankingInfo!.firstName
            self.iLastName.text = self.individualBankingInfo!.lastName
            self.iMonth.text = self.individualBankingInfo!.dobMonth
            self.iDay.text = self.individualBankingInfo!.dobDay
            self.iYear.text = self.individualBankingInfo!.dobYear
            self.iPhoneNumber.text = self.individualBankingInfo!.phone
            self.iEmail.text = self.individualBankingInfo!.email
            self.iStreetAddress.text = self.individualBankingInfo!.streetAddress
            self.iCity.text = self.individualBankingInfo!.city
            self.iState.text = self.individualBankingInfo!.state
            self.iZipCode.text = self.individualBankingInfo!.zipCode
            self.iLast4Ssn.text = self.individualBankingInfo!.ssn
            
            if individualBankingInfo!.acceptTermsOfService == "yes" {
                self.iAcceptButton.isEnabled = true
                self.iAcceptCircle.image = UIImage(systemName: "circle.fill")
            } else {
                self.iAcceptButton.isEnabled = false
                self.iAcceptCircle.image = UIImage(systemName: "circle")
            }
            
            if individualBankingInfo!.externalAccount != nil {
                if individualBankingInfo!.externalAccount!.go == "go" {
                    self.iExternalAccountLabel.text = "*****\(self.individualBankingInfo!.externalAccount!.accountNumber.suffix(4))"
                }
            }
        } else {
            //Business Info Refresh
            self.individualView.isHidden = true
            self.businessView.isHidden = false
            individualButton.backgroundColor = UIColor.white
            individualButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            businessButton.setTitleColor(UIColor.white, for: .normal)
            businessButton.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
            
            if businessBankingInfo != nil {
                
                self.bMccCode.text = businessBankingInfo!.mccCode
                self.bBusinessUrl.text = businessBankingInfo!.url
                self.bCompanyName.text = businessBankingInfo!.companyName
                self.bCompanyStreetAddress.text = businessBankingInfo!.companyStreetAddress
                self.bCompanyCity.text = businessBankingInfo!.companyStreetAddress
                self.bCompanyState.text = businessBankingInfo!.companyState
                self.bCompanyZipCode.text = businessBankingInfo!.companyZipCode
                self.bCompanyPhone.text = businessBankingInfo!.companyPhone
                self.bCompanyTaxId.text = businessBankingInfo!.companyTaxId
                
                if businessBankingInfo!.externalAccount != nil {
                    if businessBankingInfo!.externalAccount!.go == "go" {
                        self.bExternalAccountLabel.text = "*****\(businessBankingInfo!.externalAccount!.accountNumber.suffix(4))"
                    }
                }
                
//                @IBOutlet weak var bRepresentativeLabel: UILabel!
                if businessBankingInfo!.representative != nil {
                    if businessBankingInfo!.representative != nil {
                        if businessBankingInfo!.representative!.go == "go" {
                            self.bRepresentativeLabel.text = "\(businessBankingInfo!.representative!.firstName) \(businessBankingInfo!.representative!.lastName)"
                        }
                    }
                   
                }
                
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipForNowButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to continue. You would have to complete this section before posting any beautician services?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            
            let data : [String: Any] = ["accountType" : "", "stripeAccountId" : "", "externalAccountId" : ""]
            self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("BankingInfo").document().setData(data)
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                
                self.present(vc, animated: true, completion: nil)
            }
                    
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func individualButtonPressed(_ sender: Any) {
        individualView.isHidden = false
        businessView.isHidden = true
        
    }
    
    @IBAction func businessButtonPressed(_ sender: Any) {
        self.showToast(message: "This option is not yet available.", font: .systemFont(ofSize: 12))

    }
    
    //Individual
    @IBAction func iClickToViewButtonPressed(_ sender: Any) {
        iAcceptButton.isEnabled = true
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripesTermsOfService") as? StripeTermsViewController {
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func iAcceptButtonPressed(_ sender: Any) {
        if iAcceptButton.title(for: .normal) == "I accept" {
            iAcceptButton.setTitle("Don't accept", for: .normal)
            self.iAcceptCircle.image = UIImage(systemName: "circle.fill")
        } else {
            iAcceptButton.setTitle("I accept", for: .normal)
            self.iAcceptCircle.image = UIImage(systemName: "circle")
        }
    }
    
    
    @IBAction func iExternalAccountButtonPressed(_ sender: Any) {
        var acceptTermsOfService = ""
        var externalAccount = ExternalAccount(accountType: "Individual", stripeAccountId: "", externalAccountId: "", bankName: "", accountHolder: "", accountNumber: "", routingNumber: "", documentId: "", go: "")
        
        if iAcceptCircle == UIImage(systemName: "circle.fill") { acceptTermsOfService = "yes" } else { acceptTermsOfService = "no" }
        if individualBankingInfo != nil {
            if self.individualBankingInfo!.externalAccount != nil {
                externalAccount = self.individualBankingInfo!.externalAccount!
            }
        }
        
        
        individualBankingInfo = IndividualBankingInfo(acceptTermsOfService: acceptTermsOfService, mccCode: self.iMccCode.text ?? "", ip: getWiFiAddress() ?? "", businessUrl: self.iBusinessUrl.text ?? "", date: "\(Int(Date().timeIntervalSince1970))", firstName: self.iFirstName.text ?? "", lastName: self.iLastName.text ?? "", dobMonth: self.iMonth.text ?? "", dobDay: self.iDay.text ?? "", dobYear: self.iYear.text ?? "", streetAddress: self.iStreetAddress.text ?? "", line2: "", city: self.iCity.text ?? "", state: self.iState.text ?? "", zipCode: self.iZipCode.text ?? "", email: self.iEmail.text ?? "", phone: self.iPhoneNumber.text ?? "", ssn: self.iLast4Ssn.text ?? "", externalAccount: externalAccount)
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountInfo") as? AccountInfoViewController {
            
            vc.newOrEdit = self.newOrEdit
            vc.individualBankingInfo = self.individualBankingInfo
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func iSaveButtonPressed(_ sender: Any) {
        
            
            if iMccCode.text == "" {
                self.showToast(message: "Please enter a MCC Code in the alloted field.", font: .systemFont(ofSize: 12))
            } else if iBusinessUrl.text == "" {
                self.showToast(message: "Please enter your Business Url in the allotted field.", font: .systemFont(ofSize: 12))
            } else if self.iFirstName.text == "" || self.iLastName.text == "" {
                self.showToast(message: "Please enter your full name in the alloted fields.", font: .systemFont(ofSize: 12))
            } else if iMonth.text == "" || iDay.text == "" || self.iYear.text == "" {
                self.showToast(message: "Please enter your Date of Birth in the alloted field.", font: .systemFont(ofSize: 12))
            } else if iPhoneNumber.text == "" {
                self.showToast(message: "Please enter your phone number in the alloted field.", font: .systemFont(ofSize: 12))
            } else if iEmail.text == "" {
                self.showToast(message: "Please enter your email in the alloted field.", font: .systemFont(ofSize: 12))
            } else if iStreetAddress.text == "" || iCity.text == "" || iState.text == "" || iZipCode.text == "" {
                self.showToast(message: "Please enter your street address in the alloted fields.", font: .systemFont(ofSize: 12))
            } else if iLast4Ssn.text == "" || iLast4Ssn.text!.count != 4 {
                self.showToast(message: "Please enter the last 4 digits of your SSN in the alloted field.", font: .systemFont(ofSize: 12))
            } else if individualBankingInfo != nil && individualBankingInfo!.externalAccount == nil  {
                self.showToast(message: "Please add an external account by clicking the edit in the External Account allotment.", font: .systemFont(ofSize: 12))
            } else {
                if newOrEdit == "new" {
                createIndividualAccount()
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                //Edit
                updateIndividualAccount()
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
            
        }
    }
    
    //Business
    @IBAction func bClickToViewButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func bAcceptButtonPressed(_ sender: Any) {
    }
    
    @IBAction func bExternalAccountButtonPressed(_ sender: Any) {
        saveInfoForTransfer()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountInfo") as? AccountInfoViewController {
            vc.newOrEdit = self.newOrEdit
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func bRepresentativeButtonPressed(_ sender: Any) {
        saveInfoForTransfer()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = self.newOrEdit
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func bOwnersButtonPressed(_ sender: Any) {
        saveInfoForTransfer()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = self.newOrEdit
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func bSaveButtonPressed(_ sender: Any) {
        
    }
    
    private func saveInfoForTransfer() {
        var acceptTermsOfService = ""
        var externalAccount = ExternalAccount(accountType: "Business", stripeAccountId: "", externalAccountId: "", bankName: "", accountHolder: "", accountNumber: "", routingNumber: "", documentId: "", go: "")
        
        if iAcceptCircle == UIImage(systemName: "circle.fill") { acceptTermsOfService = "yes" } else { acceptTermsOfService = "no" }
        if businessBankingInfo != nil {
            if self.businessBankingInfo!.externalAccount != nil {
                externalAccount = self.businessBankingInfo!.externalAccount!
            }
        }
    
        var owners : [Person] = []
        var representative : Person = Person(stripeAccountId : "" ,  personId: "" , isPersonAnOwner: "", isPersonAnExectutive: "", firstName: "", lastName: "", month: "", day: "", year: "", streetAddress: "", city: "", state: "", zipCode: "", emailAddress: "", phoneNumber: "", taxId: "", go: "")
        
        if self.businessBankingInfo != nil {
            if self.businessBankingInfo!.owners != nil {
                owners = self.businessBankingInfo!.owners!
            }
            if self.businessBankingInfo!.representative != nil {
                representative = self.businessBankingInfo!.representative!
            }
        }
        
        businessBankingInfo = BusinessBankingInfo(acceptTermsOfService: acceptTermsOfService, mccCode: bMccCode.text ?? "", ip: getWiFiAddress() ?? "", url: bBusinessUrl.text ?? "", date: "\(Int(Date().timeIntervalSince1970))", companyName: self.bCompanyName.text ?? "", companyStreetAddress: self.bCompanyStreetAddress.text ?? "", companyCity: self.bCompanyCity.text ?? "", companyState: self.bCompanyState.text ?? "", companyZipCode: self.bCompanyZipCode.text ?? "", companyPhone: self.bCompanyPhone.text ?? "", companyTaxId: self.bCompanyTaxId.text ?? "", externalAccount: externalAccount, representative: representative, owners: owners, documentId: "")
    }
    
    private func createIndividualAccount() {
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
        let json: [String: Any] = ["mcc": "\(individualBankingInfo!.mccCode)", "ip" : "\(getWiFiAddress()!)", "url" :"\(individualBankingInfo!.businessUrl)", "date": "\(Int(Date().timeIntervalSince1970))", "first_name" : "\(individualBankingInfo!.firstName)", "last_name" : "\(individualBankingInfo!.lastName)", "dob_day" : "\(individualBankingInfo!.dobDay)", "dob_month" : "\(individualBankingInfo!.dobMonth)", "dob_year" : "\(individualBankingInfo!.dobYear)", "line_1" : "\(individualBankingInfo!.streetAddress)", "line_2" : "", "postal_code" : "\(individualBankingInfo!.zipCode)", "city" : "\(individualBankingInfo!.city)", "state" : "\(individualBankingInfo!.state)", "email" : "\(individualBankingInfo!.email)", "phone" : "\(individualBankingInfo!.phone)", "ssn" : "\(individualBankingInfo!.ssn)", "account_holder" : "\(individualBankingInfo!.externalAccount!.accountHolder)", "routing_number" : "\(individualBankingInfo!.externalAccount!.routingNumber)", "account_number" : "\(individualBankingInfo!.externalAccount!.accountNumber)"]
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/create-individual-account")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let id = json["id"] as? String,
                let externalAccountId = json["external_account"] as? String,
                let self = self else {
            // Handle error
            return
            }
            
            DispatchQueue.main.async {
                if self.newOrEdit == "new" {
                    let data : [String : Any] = ["accountType" : "Individual", "stripeAccountId" : id, "externalAccountId" : externalAccountId]
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("BankingInfo").document().setData(data)
                    
                    self.activityIndicator.stopAnimating()
                    self.showToastCompletion(message: "Banking Info Updated.", font: .systemFont(ofSize: 12))
                    
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                }
        })
        task.resume()
        
    }
    
    private func updateIndividualAccount() {
        let json: [String: Any] = ["mcc": "\(iMccCode.text!)", "url" :"\(iBusinessUrl.text!)", "first_name" : "\(iFirstName.text!)", "last_name" : "\(iLastName.text!)", "dob_day" : "\(iDay.text!)", "dob_month" : "\(iMonth.text!)", "dob_year" : "\(iYear.text!)", "line_1" : "\(iStreetAddress.text!)", "line_2" : "", "postal_code" : "\(iZipCode.text!)", "city" : "\(iCity.text!)", "state" : "\(iState.text!)", "email" : "\(iEmail.text!)", "phone" : "\(iPhoneNumber.text!)"]
        
        
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/update-individual-account")!)
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
                self.showToastCompletion(message: "Banking Info Updated.", font: .systemFont(ofSize: 12))
            }
        })
        task.resume()
    }
    
    func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
}
