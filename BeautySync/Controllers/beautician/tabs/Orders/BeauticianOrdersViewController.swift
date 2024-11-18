//
//  BeauticianOrdersViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/14/24.
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

class BeauticianOrdersViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var pendingButton: MDCButton!
    @IBOutlet weak var scheduledButton: MDCButton!
    @IBOutlet weak var completeButton: MDCButton!
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    private var orders: [Orders] = []
    private var orderType = "pending"
    
    let df = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "MM-dd-yyyy HH:mm a"

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
        
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Orders").getDocuments { documents, error in
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
    
    private func showOptions() {
        let alert = UIAlertController(title: "Are you sure you want to cancel this appointment?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            let uid = Auth.auth().currentUser!.uid
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    private func compareDates(eventDay: String, eventTime: String, status: String) {
        
        df.dateFormat = "MM-dd-yyyy HH:mm a"
        let year = "\(df.string(from: Date()))".prefix(10).suffix(4)
        let month = "\(df.string(from: Date()))".prefix(2)
        let day = "\(df.string(from: Date()))".prefix(5).suffix(2)
        var hour = "\(df.string(from: Date()))".prefix(13).suffix(2)
        let min = "\(df.string(from: Date()))".prefix(16).suffix(2)
        
        if Int(hour)! < 10 {
            hour = "0\(hour)"
        } else if Int(hour)! > 12 {
            hour = "\(Int(hour)! - 12)"
            if Int(hour)! < 10 {
                hour = "0\(hour)"
            }
        }
        print("year \(year)")
        print("month \(month)")
        print("day \(day)")
        print("hour \(hour)")
        print("min \(min)")
        
        let year1 = "\(eventDay) \(eventTime)".prefix(10).suffix(4)
        let month1 = "\(eventDay) \(eventTime)".prefix(2)
        let day1 = "\(eventDay) \(eventTime)".prefix(5).suffix(2)
        var hour1 = "\(eventDay) \(eventTime)".prefix(13).suffix(2)
        let min1 = "\(eventDay) \(eventTime)".prefix(16).suffix(2)
        
        print("year1 \(year1)")
        print("month1 \(month1)")
        print("day1 \(day1)")
        print("hour1 \(hour1)")
        print("min1 \(min1)")
        print("hour subtract \(Int(hour)! - Int(hour1)!)")
        if year == year1 {
            if month == month1 {
                if day == day1 {
                    if Int(hour1)! - Int(hour)! == 2 {
                        if Int(min)! >= Int(min1)! {
                            if status != "pending" {
                                self.showToast(message: "You cannot cancel event with less than two hours till service time.", font: .systemFont(ofSize: 12))
                            } else {
                                showOptions()
                            }
                        } else {
                            //clear
                            showOptions()
                        }
                    } else if Int(hour1)! - Int(hour)! < 2 {
                        if status != "pending" {
                            self.showToast(message: "You cannot cancel event with less than two hours till service time.", font: .systemFont(ofSize: 12))
                        } else {
                            showOptions()
                        }
                    } else {
                        //clear
                        showOptions()
                    }
                } else {
                    showOptions()
                }
            } else {
                showOptions()
            }
        } else {
            showOptions()
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
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension BeauticianOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "OrdersReusableCell", for: indexPath) as! OrdersTableViewCell
        
        var item = orders[indexPath.row]
        
        var serviceType = ""
        if item.itemType == "hairCareItems" {
            serviceType = "Hair Care"
        } else if item.itemType == "skinCareItems" {
            serviceType = "Skin Care"
        } else if item.itemType == "nailCareItems" {
            serviceType = "Nail Care"
        }
        cell.itemType.text = "\(serviceType) | \(item.itemTitle)"
        cell.serviceDate.text = "Service Date: \(item.eventDay) \(item.eventTime)"
        cell.location.text = "Location: \(item.streetAddress) \(item.beauticianCity), \(item.beauticianState) \(item.zipCode)"
        var note = ""
        if item.notesToBeautician == "" {
            note = "No Note."
        } else {
            note = "Note: \(item.notesToBeautician)"
        }
        cell.userName.text = "User: @\(item.userName)"
        cell.notesToBeautician.text = "\(note)"
        
        if self.orderType == "pending" {
            cell.cancelButtonConstraint.constant = 62
            cell.messagesButtonConstraint.constant = 62
            serviceTableView.rowHeight = 249
        } else {
            cell.cancelButtonConstraint.constant = 19
            cell.messagesButtonConstraint.constant = 19
            serviceTableView.rowHeight = 206
        }
        
        if self.orderType == "pending" {
            cell.messagesForSchedulingButton.isHidden = false
            cell.messagesButton.setTitle("Accept", for: .normal)
            cell.messagesButton.isUppercaseTitle = false
        } else {
            cell.messagesForSchedulingButton.isHidden = true
            cell.messagesButton.setTitle("Messages", for: .normal)
            cell.messagesButton.isUppercaseTitle = false
        }
        
       
        cell.messagesButtonTapped = {
            let month = "\(self.df.string(from: Date()))".prefix(2)
            let year = "\(self.df.string(from: Date()))".prefix(10).suffix(4)
            let yearMonth = "\(year), \(month)"
            print("date \(self.df.string(from: Date()))")
            print("month \(month)")
            print("year \(year)")
            print("yearMonth \(yearMonth)")
            
            
            let calendar = Calendar(identifier: .gregorian)
            var currentWeek = calendar.component(.weekOfMonth, from: Date())
            if currentWeek == 5 {
                currentWeek = 4
            }
            print("currentWeek \(currentWeek)")
            if self.orderType == "pending" {
                
                let data : [String: Any] = ["totalPay" : Double(item.itemPrice)!]
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Week").collection("Week \(currentWeek)").document().setData(data)
                
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Total").getDocument(completion: { document, error in
                    if error == nil {
                        if document != nil {
                            if document!.exists {
                                let data = document!.data()
                                if data != nil {
                                    if let total = data?["totalPay"] as? Double {
                                        let data5 : [String : Any] = ["totalPay" : total + Double(item.itemPrice)!]
                                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Total").updateData(data5)
                                    }
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : Double(item.itemPrice)!]
                                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Total").setData(data5)
                            }
                        }
                    }
                })
                
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            if document!.exists {
                                let data = document!.data()
                                if data != nil {
                                    if let total = data?["totalPay"] as? Double {
                                        let data5 : [String : Any] = ["totalPay" : total + Double(item.itemPrice)!]
                                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).updateData(data5)
                                    }
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : Double(item.itemPrice)!]
                                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).setData(data5)
                            }
                        }
                    }
                }
                
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Total").getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            if document!.exists {
                                let data = document!.data()
                                
                                if let total = data?["totalPay"] as? Double {
                                    let data5 : [String : Any] = ["totalPay" : total + Double(item.itemPrice)!]
                                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Total").updateData(data5)
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : Double(item.itemPrice)!]
                                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Total").setData(data5)
                            }
                        }
                    }
                    }
                
                self.db.collection("Orders").document(item.documentId).getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            let data = document!.data()
                            
                            if let status = data!["status"] as? String {
                                if status != "cancelled" {
                                    if let index = self.orders.firstIndex(where: { $0.documentId == item.documentId }) {
                                        let data : [String: Any] = ["status" : "scheduled"]
                                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Orders").document(item.documentId).updateData(data)
                                        self.db.collection("User").document(item.userImageId).collection("Orders").document(item.documentId).updateData(data)
                                        self.db.collection("Orders").document(item.documentId).updateData(data)
                                        self.orders.remove(at: index)
                                        self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                                    }
                                } else {
                                    
                                    if let index = self.orders.firstIndex(where: { $0.documentId == item.documentId }) {
                                        self.showToast(message: "This item has been cancelled by the User.", font: .systemFont(ofSize: 12))
                                        self.orders.remove(at: index)
                                        self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                                    }
                                }
                            }
                        }
                        }
                    }
            } else {
                //messaging
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController {
                    vc.beauticianOrUser = "Beautician"
                    vc.item = item
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        cell.cancelButtonTapped = {
            self.compareDates(eventDay: item.eventDay, eventTime: item.eventTime, status: item.status)
        }
        
        cell.messagesForSchedulingButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController {
                vc.beauticianOrUser = "Beautician"
                vc.item = item
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
