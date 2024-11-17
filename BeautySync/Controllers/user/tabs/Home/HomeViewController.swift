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
    
    var items: [ServiceItems] = []
    
    var itemType = "hairItems"
    private var totalPrice = 0.0
    private var cart : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeReusableCell")
        itemTableView.delegate = self
        itemTableView.dataSource = self
        loadItems(itemType: itemType)
        
        loadCart()
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Checkout") as? CheckoutViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func loadItems(itemType: String) {
        
        items.removeAll()
        itemTableView.reloadData()
        
        db.collection(itemType).addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let itemOrders = data["itemOrders"] as? Int, let itemRating = data["itemRating"] as? Double, let hashtags = data["hashtags"] as? [String], let liked = data["liked"] as? [String] {
                            
                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID)
                            
                            if self.items.isEmpty {
                                self.items.append(x)
                                self.itemTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.items.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.items.append(x)
                                    self.itemTableView.insertRows(at: [IndexPath(item: self.items.count - 1, section: 0)], with: .fade)
                                }
                            }
                        }
                    
                    }
                }
            }
        }
    }
    
    private func loadCart() {
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Cart").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemPrice = data["itemPrice"] as? String {
                            
                            if self.cart.count == 0 {
                                self.cart.append(doc.documentID)
                                self.totalPrice += Double(itemPrice)!
                                let num = String(format: "%.2f", self.totalPrice)
                                self.checkoutPrice.text = "$\(num)"
                            } else {
                                let index = self.cart.firstIndex { $0 == doc.documentID}
                                if index == nil {
                                    self.cart.append(doc.documentID)
                                    self.totalPrice += Double(itemPrice)!
                                    let num = String(format: "%.2f", self.totalPrice)
                                    self.checkoutPrice.text = "$\(num)"
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
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = itemTableView.dequeueReusableCell(withIdentifier: "HomeReusableCell", for: indexPath) as! HomeTableViewCell
        
        var item = items[indexPath.row]
        
        
        cell.userName.text = "\(item.beauticianUsername)"
        cell.itemTitle.text = item.itemTitle
        cell.itemDescription.text = item.itemDescription
        cell.itemPrice.text = "$\(item.itemPrice)"
        cell.itemLikes.text = "\(item.liked.count)"
        cell.itemOrders.text = "\(item.itemOrders)"
        
        if item.liked.firstIndex(of: Auth.auth().currentUser!.uid) != nil {
            cell.itemLikeImage.image = UIImage(systemName: "heart.fill")
        } else {
            cell.itemLikeImage.image = UIImage(systemName: "heart")
        }
        
       
        
        let storageRef = storage.reference()
        storageRef.child("beauticians/\(item.beauticianImageId)/profileImage/\(item.beauticianImageId).png").downloadURL { itemUrl, error in
            if itemUrl != nil {
                URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
                    // Error handling...
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async {
                        cell.userImage.image = UIImage(data: imageData)!
                        item.beauticianUserImage = UIImage(data: imageData)!
                    }
                }.resume()
            }
        }
       
        let itemRef = storage.reference()
        itemRef.child("\(item.itemType)/\(item.beauticianImageId)/\(item.documentId)/\(item.documentId)0.png").downloadURL { itemUrl, error in
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
        
        
        cell.orderButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetails") as? OrderDetailsViewController {
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
        
        cell.userImageButtonTapped = {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAsUser") as? ProfileAsUserViewController {
                vc.userId = item.beauticianImageId
                vc.beauticianOrUser = "Beautician"
                vc.item = item
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        cell.userLikeButtonTapped = {
            let data : [String: Any] = ["itemType" :  item.itemType, "itemTitle" : item.itemTitle, "itemDescription" : item.itemDescription, "itemPrice" : item.itemPrice, "imageCount" : item.imageCount, "beauticianUsername" : item.beauticianUsername, "beauticianPassion" : item.beauticianPassion, "beauticianCity" : item.beauticianCity, "beauticianState": item.beauticianState, "beauticianImageId" : item.beauticianImageId, "liked" : item.liked, "itemOrders" : item.itemOrders, "itemRating" : item.itemRating, "hashtags" : item.hashtags]
            
            if cell.itemLikeImage.image == UIImage(systemName: "heart") {
                cell.itemLikeImage.image = UIImage(systemName: "heart.fill")
                cell.itemLikes.text = "\(Int(cell.itemLikes.text!)! + 1)"
                self.db.collection(item.itemType).document(item.documentId).updateData(["liked" : FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"])])
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("UserLikes").document(item.documentId).setData(data)
            } else {
                cell.itemLikeImage.image = UIImage(systemName: "heart")
                self.db.collection(item.itemType).document(item.documentId).updateData(["liked" : FieldValue.arrayRemove(["\(Auth.auth().currentUser!.uid)"])])
                cell.itemLikes.text = "\(Int(cell.itemLikes.text!)! - 1)"
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("UserLikes").document(item.documentId).delete()
            }
        }
        
        
        
        return cell
    }
}
