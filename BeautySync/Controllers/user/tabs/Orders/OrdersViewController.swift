//
//  OrdersViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/13/24.
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

class OrdersViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var pendingButton: MDCButton!
    @IBOutlet weak var scheduledButton: MDCButton!
    @IBOutlet weak var completeButton: MDCButton!
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    private var orders: [Orders] = []
    private var orderType = "pending"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        loadOrders(orderType: orderType)
        
    }
    
    
    
    @IBAction func pendingButtonPressed(_ sender: Any) {
        orderType = "pending"
        loadOrders(orderType: orderType)
        pendingButton.setTitleColor(UIColor.white, for: .normal)
        pendingButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        scheduledButton.backgroundColor = UIColor.white
        scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func scheduledButtonPressed(_ sender: Any) {
        orderType = "scheduled"
        loadOrders(orderType: orderType)
        pendingButton.backgroundColor = UIColor.white
        pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        scheduledButton.setTitleColor(UIColor.white, for: .normal)
        scheduledButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        orderType = "complete"
        loadOrders(orderType: orderType)
        pendingButton.backgroundColor = UIColor.white
        pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        scheduledButton.backgroundColor = UIColor.white
        scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        completeButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    
    private func loadOrders(orderType: String) {
        
        orders.removeAll()
        serviceTableView.reloadData()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? Double, let hashtags = data["hashtags"] as? [String], let liked = data["liked"] as? [String], let streetAddress = data["streetAddress"] as? String, let zipCode = data["zipCode"] as? String, let eventDay = data["eventDay"] as? String, let eventTime = data["eventTime"] as? String, let notesToBeautician = data["notesToBeautician"] as? String, let userImageId = data["userImageId"] as? String, let status = data["status"] as? String, let itemId = data["itemId"] as? String, let userName = data["userName"] as? String {
                            
                            if status == orderType {
                                let x = Orders(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID, eventDay: eventDay, eventTime: eventTime, streetAddress: streetAddress, zipCode: zipCode, notesToBeautician: notesToBeautician, userImageId: userImageId, userName: userName, status: status, itemId: itemId)
                                
                                if self.orders.isEmpty {
                                    self.orders.append(x)
                                    self.serviceTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                } else {
                                    let index = self.orders.firstIndex { $0.documentId == doc.documentID }
                                    if index == nil {
                                        self.orders.append(x)
                                        self.serviceTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "OrdersReusableCell", for: indexPath) as! OrdersTableViewCell
        
        var item = orders[indexPath.row]
        
        var serviceType = ""
        if item.itemType == "hairItems" {
            serviceType = "Hair Item"
        } else if item.itemType == "makeupItems" {
            serviceType = "Makeup Item"
        } else if item.itemType == "lashItems" {
            serviceType = "Lash Item"
        }
        cell.itemType.text = serviceType
        cell.serviceDate.text = "Service Date: \(item.eventDay) \(item.eventTime)"
        cell.location.text = "Location: \(item.streetAddress) \(item.beauticianCity), \(item.beauticianState) \(item.zipCode)"
        var note = ""
        if item.notesToBeautician == "" {
            note = "No Note."
        } else {
            note = "Note: \(item.notesToBeautician)"
        }
        cell.notesToBeautician.text = "\(note)"
        cell.userName.text = "Beautician: \(item.beauticianUsername)"
        cell.cancelButtonConstraint.constant = 19
        cell.messagesButtonConstraint.constant = 19
        serviceTableView.rowHeight = 231
        
        
        cell.messagesForSchedulingButton.isHidden = true
        cell.messagesButton.setTitle("Messages For Scheduling", for: .normal)
        cell.messagesButton.isUppercaseTitle = false
        
        cell.messagesButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController {
                vc.beauticianOrUser = "User"
                vc.item = item
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.cancelButtonTapped = {
            let alert = UIAlertController(title: "Are you sure you want to cancel this appointment?", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
                let uid = Auth.auth().currentUser!.uid
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
        return cell
    }
}
