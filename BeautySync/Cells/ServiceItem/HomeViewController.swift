//
//  HomeViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/8/24.
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


class HomeViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var hairButton: MDCButton!
    @IBOutlet weak var makeupButton: MDCButton!
    @IBOutlet weak var lashButton: MDCButton!
    
    @IBOutlet weak var checkoutPrice: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    
    var hairItems: [ServiceItems] = []
    var makeupItems: [ServiceItems] = []
    var lashItems: [ServiceItems] = []
    
    var itemType = "hairItems"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func hairButtonPressed(_ sender: Any) {
        itemType = "hairItems"
        loadItems(itemType: itemType)
        hairButton.setTitleColor(UIColor.white, for: .normal)
        hairButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        makeupButton.backgroundColor = UIColor.white
        makeupButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        lashButton.backgroundColor = UIColor.white
        lashButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func makeupButtonPressed(_ sender: Any) {
        itemType = "makeupItems"
        loadItems(itemType: itemType)
        hairButton.backgroundColor = UIColor.white
        hairButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        makeupButton.setTitleColor(UIColor.white, for: .normal)
        makeupButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        lashButton.backgroundColor = UIColor.white
        lashButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func lashButtonPressed(_ sender: Any) {
        itemType = "lashItems"
        loadItems(itemType: itemType)
        hairButton.backgroundColor = UIColor.white
        hairButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        makeupButton.backgroundColor = UIColor.white
        makeupButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        lashButton.setTitleColor(UIColor.white, for: .normal)
        lashButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
    }
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
    }
    
    private func loadItems(itemType: String) {
        
        hairItems.removeAll()
        makeupItems.removeAll()
        lashItems.removeAll()
        itemTableView.reloadData()
        
        db.collection(itemType).addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        
                        if let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let itemLikes = data["itemLikes"] as? Int, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? Double, let hashtags = data["hashtags"] as? [String] {
                            
                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, itemLikes: itemLikes, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID)
                            
                            if itemType == "hairItems" {
                                if self.hairItems.isEmpty {
                                    self.hairItems.append(x)
                                    self.itemTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                } else {
                                    let index = self.hairItems.firstIndex { $0.documentId == doc.documentID }
                                    if index == nil {
                                        self.hairItems.append(x)
                                        self.itemTableView.insertRows(at: [IndexPath(item: self.hairItems.count - 1, section: 0)], with: .fade)
                                    }
                                }
                            } else if itemType == "makeupItems" {
                                if self.makeupItems.isEmpty {
                                    self.makeupItems.append(x)
                                    self.itemTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                } else {
                                    let index = self.makeupItems.firstIndex { $0.documentId == doc.documentID }
                                    if index == nil {
                                        self.makeupItems.append(x)
                                        self.itemTableView.insertRows(at: [IndexPath(item: self.makeupItems.count - 1, section: 0)], with: .fade)
                                    }
                                }
                            } else if itemType == "lashItems" {
                                if self.lashItems.isEmpty {
                                    self.lashItems.append(x)
                                    self.itemTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                } else {
                                    let index = self.lashItems.firstIndex { $0.documentId == doc.documentID }
                                    if index == nil {
                                        self.lashItems.append(x)
                                        self.itemTableView.insertRows(at: [IndexPath(item: self.lashItems.count - 1, section: 0)], with: .fade)
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


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemType == "hairItems" {
            return hairItems.count
        } else if itemType == "makeupItems" {
            return makeupItems.count
        } else if itemType == "lashItems" {
            return lashItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = itemTableView.dequeueReusableCell(withIdentifier: "HomeReusableCell", for: indexPath) as! HomeTableViewCell
        
        var item : ServiceItems?
        
        if itemType == "hairItems" {
            item = hairItems[indexPath.row]
        } else if itemType == "makeupItems" {
            item = makeupItems[indexPath.row]
        } else if itemType == "lashItems" {
            item = lashItems[indexPath.row]
        }
        
        cell.userName.text = "@\(item!.beauticianUsername)"
        cell.itemTitle.text = item!.itemTitle
        cell.itemDescription.text = item!.itemDescription
        cell.itemPrice.text = "$\(item!.itemPrice)"
        
        let storageRef = storage.reference()
        storageRef.child("beauticians/\(item!.beauticianImageId)/profileImage/\(item!.beauticianImageId).png").downloadURL { itemUrl, error in
            if itemUrl != nil {
                URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
                    // Error handling...
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async {
                        cell.userImage.image = UIImage(data: imageData)!
                        item!.beauticianUserImage = UIImage(data: imageData)!
                    }
                }.resume()
            }
        }
        
        let itemRef = storage.reference()
        itemRef.child("\(item!.itemType)/\(item!.beauticianImageId)/\(item!.documentId)/\(item!.documentId)0.png").downloadURL { itemUrl, error in
            if itemUrl != nil {
                URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
                    // Error handling...
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async {
                        cell.itemImage.image = UIImage(data: imageData)!
                        item!.itemImage = UIImage(data: imageData)!
                    }
                }.resume()
            }
        }
        
        cell.orderButtonTapped = {
            
        }
        
        cell.itemDetailButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController {
                vc.item = item!
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.userImageButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAsUser") as? ProfileAsUserViewController {
                vc.userId = item!.beauticianImageId
                vc.beauticianOrUser = "Beautician"
                vc.item = item!
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.userLikeButtonTapped = {
            
        }
        
        
        
        return cell
    }
}
