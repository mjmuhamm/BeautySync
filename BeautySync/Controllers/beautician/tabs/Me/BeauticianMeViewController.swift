//
//  MeViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class BeauticianMeViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var notificationBell: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var passion: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var hairCareButton: MDCButton!
    @IBOutlet weak var skinCareButton: MDCButton!
    @IBOutlet weak var nailCareButton: MDCButton!
    @IBOutlet weak var contentButton: MDCButton!
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    var itemType = "hairCareItems"
    var city = ""
    var state = ""
    
    var items : [ServiceItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        serviceTableView.register(UINib(nibName: "ServiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceItemReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        loadHeadingInfo()
        loadItemInfo(item: itemType)
    }
    
    private func loadHeadingInfo() {
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                        for doc in documents!.documents {
                            let data = doc.data()
                            if let username = data["username"] as? String {
                                self.userName.text = username
                            }
                        }
                }
            }
        }
        
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("BusinessInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let passion = data["passion"] as? String, let city = data["city"] as? String, let state = data["state"] as? String {
                            self.passion.text = passion
                            self.city = city
                            self.state = state
                            self.location.text = "Location: \(city), \(state)"
                        }
                    }
                }
            }
        }
        
        let storageRef = storage.reference()
        storageRef.child("beauticians/\(Auth.auth().currentUser!.email!)/profilePic/\(Auth.auth().currentUser!.uid).png").downloadURL { url, error in
            if error == nil {
                if url != nil {
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        // Error handling...
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            self.userImage.image = UIImage(data: imageData)!
                        }
                    }.resume()
                }
            }
        }
    }
    
    private func loadItemInfo(item: String) {
        
        print("item type\(item)")
        items.removeAll()
        serviceTableView.reloadData()
        
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(item).getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let hashtags = data["hashtags"] as? [String] {
                            
                            self.db.collection(itemType).document(doc.documentID).getDocument { document, error in
                                if error == nil {
                                    if document != nil {
                                        let data = document!.data()
                                        
                                        if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? Double {
                                            
                                   
                            
                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: self.userName.text!, beauticianPassion: self.passion.text!, beauticianCity: self.city, beauticianState: self.state, beauticianImageId: Auth.auth().currentUser!.uid, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID)
                            
                                if self.items.isEmpty {
                                    self.items.append(x)
                                    self.serviceTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                } else {
                                    let index = self.items.firstIndex { $0.documentId == doc.documentID }
                                    if index == nil {
                                        self.items.append(x)
                                        self.serviceTableView.insertRows(at: [IndexPath(item: self.items.count - 1, section: 0)], with: .fade)
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
        }
    }
    
    @IBAction func accountSettingsButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianAccountSettings") as? BeauticianAccountSettingsViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func notificationButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func hairCareButtonPressed(_ sender: Any) {
        itemType = "hairCareItems"
        loadItemInfo(item: itemType)
        hairCareButton.setTitleColor(UIColor.white, for: .normal)
        hairCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        skinCareButton.backgroundColor = UIColor.white
        skinCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nailCareButton.backgroundColor = UIColor.white
        nailCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func skinCareButtonPressed(_ sender: Any) {
        itemType = "skinCareItems"
        loadItemInfo(item: itemType)
        hairCareButton.backgroundColor = UIColor.white
        hairCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        skinCareButton.setTitleColor(UIColor.white, for: .normal)
        skinCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        nailCareButton.backgroundColor = UIColor.white
        nailCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func nailCareButtonPressed(_ sender: Any) {
        itemType = "nailCareItems"
        loadItemInfo(item: itemType)
        hairCareButton.backgroundColor = UIColor.white
        hairCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        skinCareButton.backgroundColor = UIColor.white
        skinCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nailCareButton.setTitleColor(UIColor.white, for: .normal)
        nailCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func contentButtonPressed(_ sender: Any) {
        itemType = "contentItems"
        hairCareButton.backgroundColor = UIColor.white
        hairCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        skinCareButton.backgroundColor = UIColor.white
        skinCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nailCareButton.backgroundColor = UIColor.white
        nailCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.setTitleColor(UIColor.white, for: .normal)
        contentButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var item = ""
        if itemType == "hairCareItems" { item = "Hair Care Item" } else if itemType == "skinCareItems" { item = "Skin Care Item" } else if itemType == "nailCareItems" { item = "Nail Care Item" } else { item = "Content Item" }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceItem") as? ServiceItemsViewController {
            vc.itemType = item
            vc.beauticianUsername = self.userName.text!
            vc.beauticianPassion = self.passion.text!
            vc.beauticianCity = self.city
            vc.beauticianState = self.state
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    

}

extension BeauticianMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemType != "contentItems" {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = serviceTableView.dequeueReusableCell(withIdentifier: "ServiceItemReusableCell", for: indexPath) as! ServiceItemTableViewCell
        
        var item = items[indexPath.row]
        
        cell.itemTitle.text = item.itemTitle
        cell.itemDescription.text = item.itemDescription
        cell.itemPrice.text = "$\(item.itemPrice)"
        cell.itemLikes.text = "\(item.liked.count)"
        cell.itemOrders.text = "\(item.itemOrders)"
        cell.itemRating.text = "\(item.itemRating)"
        
        let storageRef = storage.reference()
        storageRef.child("\(item.itemType)/\(Auth.auth().currentUser!.uid)/\(item.documentId)/\(item.documentId)0.png").downloadURL { itemUrl, error in
            if itemUrl != nil {
                URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
                    // Error handling...
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async {
                        cell.itemImage.image = UIImage(data: imageData)!
                        item.itemImage = UIImage(data: imageData)!
                    }
                }.resume()
            }
        }
        
        var item1 = ""
        if itemType == "hairCareItems" { item1 = "Hair Care Item" } else if itemType == "skinCareItems" { item1 = "Skin Care Item" } else if itemType == "nailCareItems" { item1 = "Nail Care Item" } else { item1 = "Content Item" }
        
        cell.itemEditButtonTapped = {
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceItem") as? ServiceItemsViewController {
                vc.itemType = item1
                vc.beauticianUsername = self.userName.text!
                vc.beauticianPassion = self.passion.text!
                vc.beauticianCity = self.city
                vc.beauticianState = self.state
                vc.newOrEdit = "edit"
                vc.serviceItemId = item.documentId
                vc.item = item
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.itemDetailButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController {
                vc.item = item
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
