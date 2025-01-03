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
    let dateFormatter = DateFormatter()
    
    let df1 = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "MM-dd-yyyy HH:mm a"
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        df1.dateFormat = "MM-dd-yyyy"

        serviceTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        loadOrders(orderType: orderType)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
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
        
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Orders").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? [Int], let hashtags = data["hashtags"] as? [String], let liked = data["liked"] as? [String], let streetAddress = data["streetAddress"] as? String, let zipCode = data["zipCode"] as? String, let eventDay = data["eventDay"] as? String, let eventTime = data["eventTime"] as? String, let notesToBeautician = data["notesToBeautician"] as? String, let userImageId = data["userImageId"] as? String, let status = data["status"] as? String, let itemId = data["itemId"] as? String, let userName = data["userName"] as? String, let notifications = data["notifications"] as? String, let cancelled = data["cancelled"] as? String {
                            
                                
                            if !self.moveToComplete(status: status, eventDay: eventDay, eventTime: eventTime, documentId: doc.documentID, beauticianId: Auth.auth().currentUser!.uid, userId: userImageId) {
                               
                                if status == orderType {
                                    let x = Orders(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID, eventDay: eventDay, eventTime: eventTime, streetAddress: streetAddress, zipCode: zipCode, notesToBeautician: notesToBeautician, userImageId: userImageId, userName: userName, status: status, notifications: notifications, itemId: itemId, cancelled: cancelled)
                                    
                                    if self.orders.isEmpty {
                                        self.orders.append(x)
                                        self.serviceTableView.reloadData()
                                    } else {
                                        let index = self.orders.firstIndex { $0.documentId == doc.documentID }
                                        if index == nil {
                                            self.orders.append(x)
                                            self.serviceTableView.reloadData()
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
    
    private func showOptions(documentId: String) {
        let alert = UIAlertController(title: "Are you sure you want to cancel this appointment?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            
            self.db.collection("Orders").document(documentId).getDocument { document, error in
                if error == nil {
                    if document != nil {
                        let data = document!.data()
                        
                        if data != nil {
                            if let paymentId = data!["paymentId"] as? String, let beauticianImageId = data!["beauticianImageId"] as? String, let userImageId = data!["userImageId"] as? String, let itemPrice = data!["itemPrice"] as? String {
                                
                                self.refund(paymentId: paymentId, amount: itemPrice, beauticianImageId: beauticianImageId, userImageId: userImageId)
                                
                                let data1 : [String: Any] = ["cancelled" : "yes"]
                                let data2 : [String: Any] = ["cancelled" : "yes", "status" : "cancelled"]
                                
                                self.db.collection("Orders").document(documentId).updateData(data2)
                                self.db.collection("User").document(userImageId).collection("Orders").document(documentId).updateData(data1)
                                self.db.collection("Beautician").document(beauticianImageId).collection("Orders").document(documentId).updateData(data2)
                                self.showToast(message: "This event has been cancelled.", font: .systemFont(ofSize: 12))

                            }
                        }
                    }
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func refund(paymentId: String, amount: String, beauticianImageId: String, userImageId: String) {
        
        let d = String(format: "%.0f", Double(amount)! * 100)
        
        
        let json: [String: Any] = ["paymentId": "\(paymentId)", "amount" : d]
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/refund")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let id = json["refund_id"] as? String,
                let self = self else {
            // Handle error
            return
            }
            
            DispatchQueue.main.async {
                let data : [String : Any] = ["refundId" : id, "amount" : amount, "paymentId" : paymentId, "beauticianImageId" : beauticianImageId, "userImageId" : userImageId, "date" : self.df1.string(from: Date())]
                    self.db.collection("Refunds").document().setData(data)
                
                    
                    
                
                }
        })
        task.resume()
        
    }
    
    private func compareDates(eventDay: String, eventTime: String, status: String) -> Bool {
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        let year = "\(dateFormatter.string(from: Date()))".prefix(10).suffix(4)
        let month = "\(dateFormatter.string(from: Date()))".prefix(2)
        let day = "\(dateFormatter.string(from: Date()))".prefix(5).suffix(2)
        var hour = "\(dateFormatter.string(from: Date()))".prefix(13).suffix(2)
        let min = "\(dateFormatter.string(from: Date()))".prefix(16).suffix(2)
        let amOrPm = "\(dateFormatter.string(from: Date()))".suffix(2)
        
        
        if amOrPm == "PM" {
            hour = "\(Int(hour)! + 12)"
        }
        
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
        let amOrPm1 = "\(eventDay) \(eventTime)".suffix(2)
        
        if amOrPm1 == "PM" {
            hour1 = "\(Int(hour1)! + 12)"
        }
        
        
        print("year1 \(year1)")
        print("month1 \(month1)")
        print("day1 \(day1)")
        print("hour1 \(hour1)")
        print("min1 \(min1)")
//        print("hour subtract \(Int(hour)! - Int(hour1)!)")
        if year == year1 {
            if month == month1 {
                if day == day1 {
                    if Int(hour1)! - Int(hour)! == 2 {
                        if Int(min)! >= Int(min1)! {
                            if status != "pending" {
                                return false
                            } else {
                                return true
                            }
                        } else {
                            //clear
                            return true
                        }
                    } else if Int(hour1)! - Int(hour)! < 2 {
                        if status != "pending" {
                            return false
                        } else {
                            return true
                        }
                    } else {
                        //clear
                        return true
                    }
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    
    private func moveToComplete(status: String, eventDay: String, eventTime: String, documentId: String, beauticianId: String, userId: String) -> Bool {
        
        let data : [String : Any] = ["status" : "complete"]
        
        let date1 = dateFormatter.string(from: Date())
        let year1 = date1.prefix(10).suffix(4)
        let day1 = date1.prefix(5).suffix(2)
        let month1 = date1.prefix(2)
        var hour1 = date1.prefix(13).suffix(2)
        let min1 = date1.prefix(16).suffix(2)
        let amOrPm1 = date1.suffix(2)
        //        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        
        if Int(hour1)! > 12 {
            hour1 = "\(Int(hour1)! - 12)"
        }
           
       
        print("date1 \(date1)")
        print("hour1 \(hour1)")
        print("min1 \(min1)")
        
        let date2 = "\(eventDay) \(eventTime)"
        let year2 = date2.prefix(10).suffix(4)
        let day2 = date2.prefix(5).suffix(2)
        let month2 = date2.prefix(2)
        var hour2 = date2.prefix(13).suffix(2)
        let min2 = date2.prefix(16).suffix(2)
        var amOrPm2 = date2.suffix(2)
        
            hour2 = "\(Int(hour2)! + 1)"
        
        
        print("date2 \(date2)")
        print("hour2 \(hour2)")
        print("min2 \(min2)")
        //second
        if status == "scheduled" {
            if year1 > year2 {
                //pass1
                transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                return true
            } else if (year1 == year2) {
                if month1 > month2 {
                    //pass2
                    transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                    return true
                } else {
                    if month1 == month2 {
                        if day1 > day2 {
                            //pass3
                            transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                            return true
                        } else {
                            if day1 == day2 {
                                if amOrPm1 == "PM" && amOrPm2 == "AM" {
                                    if Int(hour1)! > 1 {
                                        //pass4
                                        transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                                        return true
                                    }
                                    
                                    if min1 >= min2 {
                                        //pass5
                                        transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                                        return true
                                    }
                                } else if (amOrPm1 == "AM" && amOrPm2 == "AM") || (amOrPm1 == "PM" && amOrPm2 == "PM") {
                                    if Int(hour1)! - Int(hour2)! > 1 {
                                        //pass6
                                        transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                                        return true
                                    } else if (Int(hour1)! > Int(hour2)!) && (Int(min1)! >= Int(min2)!) {
                                        //pass7
                                        transferStatus(documentId: documentId, beauticianImageId: beauticianId, userImageId: userId)
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    private func transferStatus(documentId: String, beauticianImageId: String, userImageId: String) {
        
        db.collection("Orders").document(documentId).getDocument { document, error in
            if error == nil {
                if document != nil {
                    let data = document!.data()
                    
                    if let status = data!["status"] as? String {
                        if status != "cancelled" {
                            let data1 : [String: Any] = ["status" : "complete"]
                            self.db.collection("User").document(userImageId).collection("Orders").document(documentId).updateData(data1)
                            self.db.collection("Beautician").document(beauticianImageId).collection("Orders").document(documentId).updateData(data1)
                            self.db.collection("Orders").document(documentId).updateData(data1)
                        }
                    }
                }
            }
        }
    }
    
    
    private func transfer(transferAmount: Double, orderId: String, userImageId: String, beauticianImageId: String, eventDate: String) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let df1 = DateFormatter()
        df1.dateFormat = "MM-dd-yyyy hh:mm a"
                            
        self.db.collection("Beautician").document(beauticianImageId).collection("BankingInfo").getDocuments { documents, error in
                if error == nil {
                    if documents != nil {
                        for doc in documents!.documents {
                            let data = doc.data()
                            
                            if let stripeAccountId = data["stripeAccountId"] as? String {
                                let a = (transferAmount * 0.95) * 100
                                
                                let amount = String(format: "%.0f", a)
                                
                                let json: [String: Any] = ["amount": amount, "stripeAccountId" : stripeAccountId]
                                
                                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                                // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
                                var request = URLRequest(url: URL(string: "https://beautysync-stripeserver.onrender.com/transfer")!)
                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                request.httpMethod = "POST"
                                request.httpBody = jsonData
                                let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data,response, error) in
                                    guard let data = data,
                                          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                                          let transferId = json["transferId"], let self = self else {
                                        // Handle error
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        
                                        let data : [String: Any] = ["transferId" : transferId, "orderId" : orderId, "date" : df.string(from: Date()), "userImageId" : userImageId, "beauticianImageId" : beauticianImageId, "eventDate" : eventDate]
                                        self.db.collection("Transfers").document(orderId).setData(data)
                                        
                                        self.showToast(message: "$\(String(format: "%.2f", transferAmount * 0.95)) payout on the way.", font: .systemFont(ofSize: 12))
                                    }
                                })
                                task.resume()
                            }
                            
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
        cell.takeHome.isHidden = false
        cell.takeHome.text = "Pay: $\(String(format: "%.2f", Double(item.itemPrice)! * 0.95))"
        var note = ""
        if item.notesToBeautician == "" {
            note = "No Note."
        } else {
            note = "Note: \(item.notesToBeautician)"
        }
        cell.userName.text = "User: @\(item.userName)"
        cell.notesToBeautician.text = "\(note)"
        
        if self.orderType == "pending" && item.notifications == "yes" {
            cell.messageForSchedulingRedDot.isHidden = false
        } else if self.orderType == "scheduled" && item.notifications == "yes" {
            cell.messagesRedDot.isHidden = false
        } else {
            cell.messageForSchedulingRedDot.isHidden = true
            cell.messagesRedDot.isHidden = true
        }
        
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
        
        if self.orderType == "complete" {
            cell.cancelButton.isHidden = true
        } else {
            cell.cancelButton.isHidden = false
        }
        
        if item.cancelled == "yes" {
            cell.cancelledText.isHidden = false
            cell.cancelledText.text = "This event has been cancelled by the user."
            cell.notesToBeautician.isHidden = true
            cell.messagesForSchedulingButton.isHidden = true
            cell.cancelButton.isHidden = true
            cell.messagesButton.setTitle("Ok", for: .normal)
            cell.messagesButton.isUppercaseTitle = false
        } else {
            cell.cancelledText.isHidden = true
            cell.notesToBeautician.isHidden = false
            cell.messagesForSchedulingButton.isHidden = false
            cell.cancelButton.isHidden = false
            if self.orderType == "pending" {
                cell.messagesForSchedulingButton.isHidden = false
                cell.messagesButton.setTitle("Accept", for: .normal)
                cell.messagesButton.isUppercaseTitle = false
            } else {
                cell.messagesForSchedulingButton.isHidden = true
                cell.messagesButton.setTitle("Messages", for: .normal)
                cell.messagesButton.isUppercaseTitle = false
            }
            if self.orderType == "pending" {
                cell.cancelButtonConstraint.constant = 62
                cell.messagesButtonConstraint.constant = 62
                serviceTableView.rowHeight = 249
            } else {
                cell.cancelButtonConstraint.constant = 19
                cell.messagesButtonConstraint.constant = 19
                serviceTableView.rowHeight = 206
            }
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
            if self.orderType == "pending" && item.cancelled != "yes" {
                
                let data : [String: Any] = ["totalPay" : Double(item.itemPrice)! * 0.95]
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Week").collection("Week \(currentWeek)").document().setData(data)
                
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Total").getDocument(completion: { document, error in
                    if error == nil {
                        if document != nil {
                            if document!.exists {
                                let data = document!.data()
                                if data != nil {
                                    if let total = data?["totalPay"] as? Double {
                                        let data5 : [String : Any] = ["totalPay" : total + (Double(item.itemPrice)! * 0.95)]
                                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Month").collection(yearMonth).document("Total").updateData(data5)
                                    }
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : (Double(item.itemPrice)! * 0.95)]
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
                                        let data5 : [String : Any] = ["totalPay" : total + (Double(item.itemPrice)! * 0.95)]
                                        self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).updateData(data5)
                                    }
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" :(Double(item.itemPrice)! * 0.95)]
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
                                    let data5 : [String : Any] = ["totalPay" : total + (Double(item.itemPrice)! * 0.95)]
                                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(item.itemType).collection(item.itemId).document("Total").updateData(data5)
                                }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : (Double(item.itemPrice)! * 0.95)]
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
                                        self.serviceTableView.reloadData()
//                                        self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                                    }
                                } else {
                                    
                                    if let index = self.orders.firstIndex(where: { $0.documentId == item.documentId }) {
                                        self.showToast(message: "This item has been cancelled by the User.", font: .systemFont(ofSize: 12))
//                                        self.orders.remove(at: index)
                                        self.orders.remove(at: index)
                                        self.serviceTableView.reloadData()
//                                        self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                                    }
                                }
                            }
                        }
                        }
                    }
            } else if item.cancelled == "yes" {
                if let index = self.orders.firstIndex(where: { $0.documentId == item.documentId }) {
                    let data : [String: Any] = ["status" : "cancelled"]
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Orders").document(item.documentId).updateData(data)
                    
                    self.orders.remove(at: index)
                    self.serviceTableView.reloadData()
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
            if !self.compareDates(eventDay: item.eventDay, eventTime: item.eventTime, status: item.status) {
                self.showToast(message: "You cannot cancel event with less than two hours till service time.", font: .systemFont(ofSize: 12))
            } else {
                //showOptions
                let alert = UIAlertController(title: "Are you sure you want to cancel this appointment?", message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
                    
                    self.db.collection("Orders").document(item.documentId).getDocument { document, error in
                        if error == nil {
                            if document != nil {
                                let data = document!.data()
                                
                                if data != nil {
                                    if let paymentId = data!["paymentId"] as? String, let beauticianImageId = data!["beauticianImageId"] as? String, let userImageId = data!["userImageId"] as? String, let itemPrice = data!["itemPrice"] as? String {
                                        
                                        
                                        self.refund(paymentId: paymentId, amount: itemPrice, beauticianImageId: beauticianImageId, userImageId: userImageId)
                                        
                                        let data1 : [String: Any] = ["cancelled" : "yes"]
                                        let data2 : [String: Any] = ["cancelled" : "yes", "status" : "cancelled"]
                                        
                                        self.db.collection("Orders").document(item.documentId).updateData(data2)
                                        self.db.collection("User").document(userImageId).collection("Orders").document(item.documentId).updateData(data1)
                                        self.db.collection("Beautician").document(beauticianImageId).collection("Orders").document(item.documentId).updateData(data2)
                                        
                                        if let index = self.orders.firstIndex(where: { $0.documentId == item.documentId }) {
                                            self.orders.remove(at: index)
                                            self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                                            self.showToast(message: "This item has been cancelled.", font: .systemFont(ofSize: 12))
                                        }

                                    }
                                }
                            }
                        }
                    }
                    
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
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
