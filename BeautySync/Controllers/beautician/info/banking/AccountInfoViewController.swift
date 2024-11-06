//
//  AccountInfoViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AccountInfoViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var accountHolder: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var routingNumber: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var individualBankingInfo: IndividualBankingInfo?
    var businessBankingInfo: BusinessBankingInfo?

    var newOrEdit = ""
    var accountType = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.isHidden = true
        if individualBankingInfo != nil {
            //Individual
            self.accountType = "Individual"
            if individualBankingInfo!.externalAccount != nil {
                bankName.text = individualBankingInfo!.externalAccount!.bankName
                self.accountHolder.text = individualBankingInfo!.externalAccount!.accountHolder
                self.accountNumber.text = individualBankingInfo!.externalAccount!.accountNumber
                self.routingNumber.text = individualBankingInfo!.externalAccount!.routingNumber
            }
        }
        
        //Business
        self.accountType = "Business"
        if businessBankingInfo != nil {
            if businessBankingInfo!.externalAccount != nil {
                bankName.text = businessBankingInfo!.externalAccount!.bankName
                accountHolder.text = businessBankingInfo!.externalAccount!.accountHolder
                accountNumber.text = businessBankingInfo!.externalAccount!.accountNumber
                self.routingNumber.text = businessBankingInfo!.externalAccount!.routingNumber
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if bankName.text == "" {
            self.showToast(message: "Please enter your bank name in the alloted field.", font: .systemFont(ofSize: 12))
        } else if accountHolder.text == "" {
            self.showToast(message: "Please enter the account holder of this account in the alloted field.", font: .systemFont(ofSize: 12))
        } else if accountNumber.text == nil || accountNumber.text!.count < 5 {
            self.showToast(message: "Please enter your Account Number in the alloted field.", font: .systemFont(ofSize: 12))
        } else if routingNumber.text == nil || routingNumber.text!.count != 9 {
            self.showToast(message: "Please enter your routing number in the alloted field.", font: .systemFont(ofSize: 12))
        } else {
            if individualBankingInfo != nil {
                if newOrEdit == "new" {
                    self.individualBankingInfo!.externalAccount = ExternalAccount(accountType: "Individual", stripeAccountId: "", externalAccountId: "", bankName: self.bankName.text!, accountHolder: self.accountHolder.text!, accountNumber: self.accountNumber.text!, routingNumber: self.routingNumber.text!, documentId: "", go: "go")
                    
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianBankingInfo") as? BeauticianBankingViewController {
                        vc.newOrEdit = self.newOrEdit
                        vc.individualBankingInfo = self.individualBankingInfo
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    //edit
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    deleteExternalAccount(stripeAccountId: self.individualBankingInfo!.externalAccount!.stripeAccountId, externalAccount: self.individualBankingInfo!.externalAccount!.externalAccountId)
                }
            } else {
                //Business Banking Info
                if newOrEdit == "new" {
                    self.businessBankingInfo!.externalAccount = ExternalAccount(accountType: "Business", stripeAccountId: "", externalAccountId: "", bankName: self.bankName.text!, accountHolder: self.accountHolder.text!, accountNumber: self.accountNumber.text!, routingNumber: self.routingNumber.text!, documentId: "", go: "go")
                    
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianBankingInfo") as? BeauticianBankingViewController {
                        vc.newOrEdit = self.newOrEdit
                        vc.businessBankingInfo = self.businessBankingInfo
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    deleteExternalAccount(stripeAccountId: self.businessBankingInfo!.externalAccount!.stripeAccountId, externalAccount: self.businessBankingInfo!.externalAccount!.externalAccountId)
                }
            }
            
        }
    }
    
    private func createExternalAccount(stripeAccountId: String) {
        let json: [String: Any] = ["stripeAccountId" : "\(stripeAccountId)", "account_holder" : "\(self.accountHolder.text!)", "account_number": "\(self.accountNumber.text!)", "routing_number" : "\(self.routingNumber.text!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/create-bank-account")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let externalAccount = json["externalAccount"],
                let self = self else {
            // Handle error
            return
            }
            DispatchQueue.main.async {
                let data : [String:Any] = ["accountType": self.accountType, "stripeAccountId" : stripeAccountId, "externalAccountId" : "\(externalAccount)"]
                self.db.collection("Beautician").document("\(Auth.auth().currentUser!.email!)").collection("BankingInfo").document(UUID().uuidString).setData(data)
                self.showToastCompletion1(message: "External Account Info Updated.", font: .systemFont(ofSize: 12))
            }
        })
        task.resume()
    }
    
    private func deleteExternalAccount(stripeAccountId: String, externalAccount: String) {
        let json: [String: Any] = ["stripeAccountId" : "\(stripeAccountId)", "externalAccountId" : "\(externalAccount)"]
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/delete-bank-account")!)
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
            createExternalAccount(stripeAccountId: stripeAccountId)
            
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
    
    func showToastCompletion1(message : String, font: UIFont) {
        
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
                vc.newOrEdit = "edit"
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
}
