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
    
    let dateFormatter = DateFormatter()
    
    private var orders: [Orders] = []
    private var orderType = "pending"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        
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
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? [Int], let hashtags = data["hashtags"] as? [String], let liked = data["liked"] as? [String], let streetAddress = data["streetAddress"] as? String, let zipCode = data["zipCode"] as? String, let eventDay = data["eventDay"] as? String, let eventTime = data["eventTime"] as? String, let notesToBeautician = data["notesToBeautician"] as? String, let userImageId = data["userImageId"] as? String, let status = data["status"] as? String, let itemId = data["itemId"] as? String, let userName = data["userName"] as? String {
                            
                            if status == "scheduled" {
                                self.moveToComplete(eventDay: eventDay, eventTime: eventTime, documentId: doc.documentID, beauticianId: beauticianImageId, userId: Auth.auth().currentUser!.uid)
                            }
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
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        let year = "\(dateFormatter.string(from: Date()))".prefix(10).suffix(4)
        let month = "\(dateFormatter.string(from: Date()))".prefix(2)
        let day = "\(dateFormatter.string(from: Date()))".prefix(5).suffix(2)
        var hour = "\(dateFormatter.string(from: Date()))".prefix(13).suffix(2)
        let min = "\(dateFormatter.string(from: Date()))".prefix(16).suffix(2)
        
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
    
    private func moveToComplete(eventDay: String, eventTime: String, documentId: String, beauticianId: String, userId: String) {
        
        let data : [String : Any] = ["status" : "complete"]
        
        let date1 = dateFormatter.string(from: Date())
        let year1 = date1.prefix(10).suffix(4)
        let day1 = date1.prefix(5).suffix(2)
        let month1 = date1.prefix(2)
        var hour1 = date1.prefix(13).suffix(2)
        let min1 = date1.prefix(16).suffix(2)
        let amOrPm1 = date1.suffix(2)
        //        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        
        print("date1 \(date1)")
        
        if Int(hour1)! == 12 {
            hour1 = "\(1)"
        } else {
            hour1 = "\(Int(hour1)! + 1)"
        }
        
        let date2 = "\(eventDay) \(eventTime)"
        let year2 = date2.prefix(10).suffix(4)
        let day2 = date2.prefix(5).suffix(2)
        let month2 = date2.prefix(2)
        var hour2 = date2.prefix(13).suffix(2)
        let min2 = date2.prefix(16).suffix(2)
        let amOrPm2 = date2.suffix(2)
        
        print("date2 \(date2)")
        if year1 == year2 && month1 == month2 && day1 == day2 && amOrPm1 == amOrPm2 {
            if Int(hour1)! >= Int(hour2)! && Int(min1)! >= Int(min2)!  {
                //passed event
                self.db.collection("Orders").document(documentId).updateData(data)
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").document(documentId).updateData(data)
                self.db.collection("Beautician").document(beauticianId).collection("Orders").document(documentId).updateData(data)
            }
        } else if year1 == year2 && month1 == month2 && day1 == day2 {
            if amOrPm1 == "PM" && amOrPm2 == "AM" {
                if Int(min1)! >= Int(min2)! {
                    //passed event
                    self.db.collection("Orders").document(documentId).updateData(data)
                    self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").document(documentId).updateData(data)
                    self.db.collection("Beautician").document(beauticianId).collection("Orders").document(documentId).updateData(data)
                }
            }
        } else if year1 > year2 || year1 == year2 && month1 > month2 || year1 == year2 && month1 == month2 && day1 > day2 {
            //passed event
            self.db.collection("Orders").document(documentId).updateData(data)
            self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").document(documentId).updateData(data)
            self.db.collection("Beautician").document(beauticianId).collection("Orders").document(documentId).updateData(data)
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
        
        if orderType == "complete" {
            cell.cancelButton.setTitle("Review", for: .normal)
            cell.cancelButton.isUppercaseTitle = false
        }
        
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
            if self.orderType != "complete" {
                self.compareDates(eventDay: item.eventDay, eventTime: item.eventTime, status: item.status)
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserReview") as? UserReviewsViewController {
                    vc.item = item
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        
        
        
        return cell
    }
}
