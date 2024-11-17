//
//  ProfileAsUserViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/8/24.
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

class ProfileAsUserViewController: UIViewController {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var passionStatement: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var button1: MDCButton!
    @IBOutlet weak var button2: MDCButton!
    @IBOutlet weak var button3: MDCButton!
    @IBOutlet weak var button4: MDCButton!

    @IBOutlet weak var serviceTableView: UITableView!
    
    var beauticianOrUser = ""
    var userId = ""
    
    var item: ServiceItems?
    var itemType = "hairCareItems"
    
    //Beautician
    private var items : [ServiceItems] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.register(UINib(nibName: "ServiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceItemReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        if item != nil {
            loadBeauticianInfo(userId: item!.beauticianImageId)
            loadBeauticianItems(itemType: itemType)
            self.userName.text = "\(item!.beauticianUsername)"
            if item!.beauticianUserImage != nil {
                self.userImage.image = item!.beauticianUserImage
            }
        }

        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func button1Pressed(_ sender: Any) {
        if beauticianOrUser == "Beautician" {
            itemType = "hairCareItems"
            loadBeauticianItems(itemType: itemType)
        }
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button3.backgroundColor = UIColor.white
        button3.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button4.backgroundColor = UIColor.white
        button4.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        if beauticianOrUser == "Beautician" {
            itemType = "skinCareItems"
            loadBeauticianItems(itemType: itemType)
        }
        button1.backgroundColor = UIColor.white
        button1.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        button3.backgroundColor = UIColor.white
        button3.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button4.backgroundColor = UIColor.white
        button4.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        if beauticianOrUser == "Beautician" {
            itemType = "nailCareItems"
            loadBeauticianItems(itemType: itemType)
        }
        button1.backgroundColor = UIColor.white
        button1.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button3.setTitleColor(UIColor.white, for: .normal)
        button3.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        button4.backgroundColor = UIColor.white
        button4.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        if beauticianOrUser == "Beautician" {
            itemType = "contentItems"
            loadBeauticianItems(itemType: itemType)
        }
        button1.backgroundColor = UIColor.white
        button1.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button3.backgroundColor = UIColor.white
        button3.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        button4.setTitleColor(UIColor.white, for: .normal)
        button4.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    
    private func loadBeauticianInfo(userId: String) {
        
        
        
        db.collection("Beautician").document(userId).collection("BusinessInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let passionStatement = data["passion"] as? String, let city = data["city"] as? String, let state = data["state"] as? String {
                            self.passionStatement.text = "\(passionStatement)"
                            self.location.text = "Location: \(city), \(state)"
                        }
                    }
                }
            }
        }
    }
    
    private func loadBeauticianItems(itemType: String) {
            
            items.removeAll()
            serviceTableView.reloadData()
            
        db.collection("Beautician").document(self.userId).collection(itemType).getDocuments { documents, error in
                if error == nil {
                    if documents != nil {
                        for doc in documents!.documents {
                            let data = doc.data()
                            
                            if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? Double, let hashtags = data["hashtags"] as? [String], let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let liked = data["liked"] as? [String] {
                                
                                let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID )
                                
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

extension ProfileAsUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemType != "contentItems" && beauticianOrUser == "Beautician" {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "ServiceItemReusableCell", for: indexPath) as! ServiceItemTableViewCell
        
        var item = items[indexPath.row]
        
        cell.itemEditButton.isHidden = true
        cell.itemTitle.text = item.itemTitle
        cell.itemDescription.text = item.itemDescription
        cell.itemPrice.text = "$\(item.itemPrice)"
        
        let storageRef = storage.reference()
        storageRef.child("\(item.itemType)/\(item.beauticianImageId)/\(item.documentId)/\(item.documentId)0.png").downloadURL { itemUrl, error in
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
        
        cell.itemDetailButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController {
                vc.item = item
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
