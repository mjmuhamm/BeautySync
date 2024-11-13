//
//  CheckoutViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Stripe
import StripePaymentsUI
import StripePaymentSheet
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class CheckoutViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var paymentSheet: PaymentSheet?
    private var paymentId = ""
    let backendCheckoutUrl = URL(string: "http://beautysync-stripeserver.onrender.com/create-payment-intent")!
    
//    let backendCheckoutUrl = URL(string: "http://10.0.1.68:4242/create-payment-intent")!
    @IBOutlet weak var serviceTableView: UITableView!
    
    @IBOutlet weak var serviceTotal: UILabel!
    @IBOutlet weak var taxesAndFees: UILabel!
    @IBOutlet weak var checkoutTotal: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var totalPrice = 0.0
    
    @IBOutlet weak var payButton: MDCButton!
    
    var items : [CheckoutItems] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceTableView.register(UINib(nibName: "CheckoutTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        payButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        payButton.isEnabled = false
        
        payButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        payButton.layer.cornerRadius = 2
        
        loadItems()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
    }
    
    private func loadItems() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Cart").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let liked = data["liked"] as? [String], let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? Double, let hashtags = data["hashtags"] as? [String], let eventDay = data["eventDay"] as? String, let eventTime = data["eventTime"] as? String, let streetAddress = data["streetAddress"] as? String, let zipCode = data["zipCode"] as? String, let noteToBeautician = data["notesToBeautician"] as? String {
                            
                            let x = CheckoutItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID, eventDay: eventDay, eventTime: eventTime, streetAddress: streetAddress, zipCode: zipCode, noteToBeautician: noteToBeautician)
                            
                            
                            if self.items.count == 0 {
                                self.items.append(x)
                                self.totalPrice += Double(itemPrice)!
                                let a = String(format: "%.2f", self.totalPrice)
                                let taxesAndFees = self.totalPrice * 0.125
                                let b = String(format: "%.2f", taxesAndFees)
                                let finalTotal = self.totalPrice + taxesAndFees
                                let c = String(format: "%.2f", finalTotal)
                                self.serviceTotal.text = "$\(a)"
                                self.taxesAndFees.text = "$\(b)"
                                self.checkoutTotal.text = "$\(c)"
                                if documents!.documents.count < 2 {
                                    print("happened once 1")
                                    self.fetchPaymentIntent(costOfEvent: finalTotal)
                                }
                                self.serviceTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.items.firstIndex { $0.documentId == doc.documentID }
                                
                                if index == nil {
                                    self.items.append(x)
                                    self.totalPrice += Double(itemPrice)!
                                    let a = String(format: "%.2f", self.totalPrice)
                                    let taxesAndFees = self.totalPrice * 0.125
                                    let b = String(format: "%.2f", taxesAndFees)
                                    let finalTotal = self.totalPrice + taxesAndFees
                                    let c = String(format: "%.2f", finalTotal)
                                    self.serviceTotal.text = "$\(a)"
                                    self.taxesAndFees.text = "$\(b)"
                                    self.checkoutTotal.text = "$\(c)"
                                    if self.items.count == documents!.documents.count {
                                        self.fetchPaymentIntent(costOfEvent: finalTotal)
                                    }
                                    self.serviceTableView.insertRows(at: [IndexPath(item:self.items.count - 1, section: 0)], with: .fade)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func fetchPaymentIntent(costOfEvent: Double) {
        
        let cost = costOfEvent * 100
        let a = String(format: "%.0f", cost)
        
        let json: [String: Any] = ["amount": a]
        print("fetch payment happening")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: backendCheckoutUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
          guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let customerId = json["customer"] as? String,
                let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                let IntentClientSecret = json["paymentIntent"] as? String,
                let publishableKey = json["publishableKey"] as? String,
                let paymentId = json["paymentId"] as? String,
                let self = self else {
            // Handle error
            return
          }

            print("fetch payment succeeded")
            STPAPIClient.shared.publishableKey = publishableKey
          // MARK: Create a PaymentSheet instance
          var configuration = PaymentSheet.Configuration()
          configuration.merchantDisplayName = "BeautySync, Inc."
          configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
          // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
          // methods that complete payment after a delay, like SEPA Debit and Sofort.
          configuration.allowsDelayedPaymentMethods = true
          self.paymentSheet = PaymentSheet(paymentIntentClientSecret: IntentClientSecret, configuration: configuration)
           

          DispatchQueue.main.async {
              self.activityIndicator.stopAnimating()
              self.activityIndicator.isHidden = true
              
            self.payButton.isEnabled = true
              self.paymentId = paymentId
          }
        })
        task.resume()
    }
    
    @objc
    func didTapCheckoutButton() {
            // MARK: Start the checkout process
            paymentSheet?.present(from: self) { paymentResult in
                // MARK: Handle the payment result
                switch paymentResult {
                case .completed:
                    self.saveInfo()
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                case .canceled:
                    print("Canceled!")
                case .failed(let error):
                    self.showToast(message: "Order Failed. Please check your information and try again.", font: .systemFont(ofSize: 12))
                }
            }
        }
    
    private func saveInfo() {
        
        for i in 0..<items.count {
            var documentId = UUID().uuidString
            
            let data : [String: Any] = ["itemType" :  items[i].itemType, "itemTitle" : items[i].itemTitle, "itemDescription" : items[i].itemDescription, "itemPrice" : items[i].itemPrice, "imageCount" : items[i].imageCount, "beauticianUsername" : items[i].beauticianUsername, "beauticianPassion" : items[i].beauticianPassion, "beauticianCity" : items[i].beauticianCity, "beauticianState": items[i].beauticianState, "beauticianImageId" : items[i].beauticianImageId, "liked" : items[i].liked, "itemOrders" : items[i].itemOrders, "itemRating" : items[i].itemRating, "hashtags" : items[i].hashtags, "eventDay" : items[i].eventDay, "eventTime": items[i].eventTime, "streetAddress" : items[i].streetAddress, "zipCode" : items[i].zipCode, "notesToBeautician" : items[i].noteToBeautician]
            
            let data1 : [String: Any] = ["itemType" :  items[i].itemType, "itemTitle" : items[i].itemTitle, "itemDescription" : items[i].itemDescription, "itemPrice" : items[i].itemPrice, "imageCount" : items[i].imageCount, "beauticianUsername" : items[i].beauticianUsername, "beauticianPassion" : items[i].beauticianPassion, "beauticianCity" : items[i].beauticianCity, "beauticianState": items[i].beauticianState, "beauticianImageId" : items[i].beauticianImageId, "liked" : items[i].liked, "itemOrders" : items[i].itemOrders, "itemRating" : items[i].itemRating, "hashtags" : items[i].hashtags, "eventDay" : items[i].eventDay, "eventTime": items[i].eventTime, "streetAddress" : items[i].streetAddress, "zipCode" : items[i].zipCode, "notesToBeautician" : items[i].noteToBeautician, "paymentId" : self.paymentId]
            
            db.collection("User").document(Auth.auth().currentUser!.uid).collection("PendingOrders").document(documentId).setData(data)
            db.collection("PendingOrders").document(documentId).setData(data1)
            db.collection("Beautician").document(items[i].beauticianImageId).collection("PendingOrders").document(documentId).setData(data)
            
            self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Cart").document(items[i].documentId).delete()
            
        }
        
        self.showToastCompletion(message: "Order Processed! Please view your Orders Tab for updates.", font: .systemFont(ofSize: 12))
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

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "CheckoutReusableCell", for: indexPath) as! CheckoutTableViewCell
        
        var item = items[indexPath.row]
        
        cell.itemTitle.text = item.itemTitle
        cell.serviceCost.text = "$\(item.itemPrice)"
        cell.location.text = "Location: \(item.streetAddress) \(item.beauticianCity), \(item.beauticianState) \(item.zipCode)"
        cell.date.text = "Date of Service: \(item.eventDay) \(item.eventTime)"
        cell.noteToBeautician.text = "Note: \(item.noteToBeautician)"
        
        
        return cell
    }
}
