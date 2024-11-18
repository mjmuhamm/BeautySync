//
//  MessagesViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/15/24.
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

class MessagesViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let storage2 = Storage.storage()

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    
    @IBOutlet weak var changeDateButton: MDCButton!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    var item : Orders?
    var beauticianOrUser = ""
    
    var messages : [Messages] = []
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    var userImage : UIImage?
    var beauticianImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"

        messageTableView.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesReusableCell")
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        changeDateButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        changeDateButton.layer.cornerRadius = 5
        
        if beauticianOrUser == "User" {
            changeDateButton.isHidden = true
            self.userName.text = "Beautician: @\(item!.beauticianUsername)"
        } else {
            self.userName.text = "User: @\(item!.userName)"
        }
        loadEventInfo()
        loadInfo()
        self.compareDates(eventDay: item!.eventDay, eventTime: item!.eventTime)
        
    }
    
    private func loadInfo() {
        
        storage.reference().child("beauticians/\(item!.beauticianImageId)/profileImage/\(item!.beauticianImageId).png").downloadURL { url, error in
            if error == nil {
                if url != nil {
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        // Error handling...
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            self.beauticianImage = UIImage(data: imageData)!
                        }
                    }.resume()
                }
            }
        }
        
        storage2.reference().child("users/\(item!.userImageId)/profileImage/\(item!.userImageId).png").downloadURL { url, error in
            if error == nil {
                if url != nil {
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        // Error handling...
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            self.userImage = UIImage(data: imageData)!
                        }
                    }.resume()
                }
            }
        }
        
        loadMessages()
    }
    
    private func loadMessages() {
        db.collection("Orders").document(item!.documentId).collection("Messages").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let message = data["message"] as? String, let date = data["date"] as? String, let beauticianOrUser = data["beauticianOrUser"] as? String {
                            
                            
                            let x = Messages(message: message, date: date, beauticianOrUser: beauticianOrUser, documentId: doc.documentID)
                            
                            if self.messages.isEmpty {
                                self.messages.append(x)
                                self.messageTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.messages.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.messages.append(x)
                                    self.messages = self.messages.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
                                    self.messageTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadEventInfo() {
        db.collection("Orders").document(item!.documentId).addSnapshotListener { document, error in
            if error == nil {
                if document != nil {
                    let data = document!.data()
                    
                    if let eventDay = data!["eventDay"] as? String, let eventTime = data!["eventTime"] as? String {
                        self.serviceDate.text = "Service Date: \(eventDay) \(eventTime)"
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
    private func compareDates(eventDay: String, eventTime: String) {
        
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
                            self.changeDateButton.isHidden = true
                        } else {
                            //clear
                            self.changeDateButton.isHidden = false
                        }
                    } else if Int(hour1)! - Int(hour)! < 2 {
                        self.changeDateButton.isHidden = true
                    } else {
                        //clear
                        self.changeDateButton.isHidden = false
                    }
                } else {
                    self.changeDateButton.isHidden = false
                }
            } else {
                self.changeDateButton.isHidden = false
            }
        } else {
            self.changeDateButton.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDateButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Scheduling") as? SchedulingViewController {
            vc.item = self.item
            vc.beauticianOrUser = self.beauticianOrUser
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        if messageText.text == "" {
            self.showToast(message: "Please enter a message in the alloted field.", font: .systemFont(ofSize: 12))
        } else {
            let data: [String: Any] = ["message" : self.messageText.text!, "date" : dateFormatter.string(from: Date()), "beauticianOrUser" : beauticianOrUser]
            
            db.collection("Orders").document(item!.documentId).collection("Messages").document().setData(data)
            messageText.text = ""
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

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = messageTableView.dequeueReusableCell(withIdentifier: "MessagesReusableCell", for: indexPath) as! MessagesTableViewCell
        
        var item = messages[indexPath.row]
        
        if self.beauticianOrUser == item.beauticianOrUser {
            cell.homeUserImage.isHidden = false
            cell.homeMessage.isHidden = false
            cell.homeDate.isHidden = false
            cell.awayUserImage.isHidden = true
            cell.awayMessage.isHidden = true
            cell.awayDate.isHidden = true
            cell.togetherMessage.isHidden = true
            
            if self.beauticianOrUser == "User" {
                if self.userImage != nil {
                    cell.homeUserImage.image = self.userImage
                }
            } else {
                if self.beauticianImage != nil {
                    cell.homeUserImage.image = self.beauticianImage
                }
            }
            cell.homeMessage.text = item.message
            
            
            var month = item.date.prefix(2)
            var day = item.date.prefix(5).suffix(2)
            var year = item.date.prefix(10).suffix(4)
            var hour = item.date.prefix(13).suffix(2)
            var min = item.date.prefix(16).suffix(2)
            var amOrPm = ""
            
            if Int(hour)! > 12 {
                hour = "\(Int(hour)! - 12)"
                amOrPm = "PM"
                if Int(hour)! < 10 {
                    hour = "0\(hour)"
                }
            } else { amOrPm = "AM" }
            
            cell.homeDate.text = "\(month)-\(day)-\(year) \(hour):\(min) \(amOrPm)"
            
            
        } else if item.beauticianOrUser != "" {
            cell.homeUserImage.isHidden = true
            cell.homeMessage.isHidden = true
            cell.homeDate.isHidden = true
            cell.awayUserImage.isHidden = false
            cell.awayMessage.isHidden = false
            cell.awayDate.isHidden = false
            cell.togetherMessage.isHidden = true
            
            cell.awayMessage.text = item.message
            
            var month = item.date.prefix(2)
            var day = item.date.prefix(5).suffix(2)
            var year = item.date.prefix(10).suffix(4)
            var hour = item.date.prefix(13).suffix(2)
            var min = item.date.prefix(16).suffix(2)
            var amOrPm = ""
            
            if Int(hour)! > 12 {
                hour = "\(Int(hour)! - 12)"
                amOrPm = "PM"
                if Int(hour)! < 10 {
                    hour = "0\(hour)"
                }
            } else { amOrPm = "AM" }
            
            cell.awayDate.text = "\(month)-\(day)-\(year) \(hour):\(min) \(amOrPm)"
            
            if self.beauticianOrUser == "User" {
                if self.userImage != nil {
                    cell.awayUserImage.image = self.userImage
                }
            } else {
                if self.beauticianImage != nil {
                    cell.awayUserImage.image = self.beauticianImage
                }
            }
        } else {
            cell.homeUserImage.isHidden = true
            cell.homeMessage.isHidden = true
            cell.homeDate.isHidden = true
            cell.awayUserImage.isHidden = true
            cell.awayMessage.isHidden = true
            cell.awayDate.isHidden = true
            cell.togetherMessage.isHidden = false
            
            cell.togetherMessage.text = "\(item.message)"
        }
        
        
       
        
//        let storageRef = storage.reference()
//        storageRef.child("beauticians/\(item.beauticianImageId)/profileImage/\(item.beauticianImageId).png").downloadURL { itemUrl, error in
//            if itemUrl != nil {
//                URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
//                    // Error handling...
//                    guard let imageData = data else { return }
//                    
//                    DispatchQueue.main.async {
//                        cell.userImage.image = UIImage(data: imageData)!
//                    }
//                }.resume()
//            }
//        }
       
        
        
        
        return cell
    }
}
