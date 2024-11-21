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
    
    @IBOutlet weak var hairCareButton: MDCButton!
    @IBOutlet weak var skinCareButton: MDCButton!
    @IBOutlet weak var nailCareButton: MDCButton!
    
    @IBOutlet weak var checkoutPrice: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    
    var items: [ServiceItems] = []
    
    var itemType = "hairCareItems"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
    }
    
    @IBAction func hairCareButtonPressed(_ sender: Any) {
        itemType = "hairCareItems"
        loadItems(itemType: itemType)
        hairCareButton.setTitleColor(UIColor.white, for: .normal)
        hairCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        skinCareButton.backgroundColor = UIColor.white
        skinCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nailCareButton.backgroundColor = UIColor.white
        nailCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func skinCareButtonPressed(_ sender: Any) {
        itemType = "skinCareItems"
        loadItems(itemType: itemType)
        hairCareButton.backgroundColor = UIColor.white
        hairCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        skinCareButton.setTitleColor(UIColor.white, for: .normal)
        skinCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        nailCareButton.backgroundColor = UIColor.white
        nailCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func nailCareButtonPressed(_ sender: Any) {
        itemType = "nailCareItems"
        loadItems(itemType: itemType)
        hairCareButton.backgroundColor = UIColor.white
        hairCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        skinCareButton.backgroundColor = UIColor.white
        skinCareButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        nailCareButton.setTitleColor(UIColor.white, for: .normal)
        nailCareButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
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
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Cart").addSnapshotListener { documents, error in
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
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Likes").document(item.documentId).setData(data)
                
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            let data = document!.data()
                            
                            if data != nil {
                                
                                if let itemCount = data!["itemCount"] as? Int {
                                    
                                    let data1: [String : Any] = ["itemCount" : itemCount + 1]
                                    self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).updateData(data1)
                                }
                            } else {
                                let data1: [String : Any] = ["itemCount" : 1, "beauticianImageId" : item.beauticianImageId, "beauticianUsername" : item.beauticianUsername, "beauticianPassion" : item.beauticianPassion, "beauticianCity" : item.beauticianCity, "beauticianState" : item.beauticianState]
                                
                                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).setData(data1)
                            }
                        }
                    }
                }
                
            } else {
                cell.itemLikeImage.image = UIImage(systemName: "heart")
                self.db.collection(item.itemType).document(item.documentId).updateData(["liked" : FieldValue.arrayRemove(["\(Auth.auth().currentUser!.uid)"])])
                cell.itemLikes.text = "\(Int(cell.itemLikes.text!)! - 1)"
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Likes").document(item.documentId).delete()
                
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            let data = document!.data()
                            if data != nil {
                                if let itemCount = data!["itemCount"] as? Int {
                                    if itemCount == 1 {
                                        self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).delete()
                                    } else {
                                        let data1: [String : Any] = ["itemCount" : itemCount - 1]
                                        self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.beauticianImageId).updateData(data1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
        return cell
    }
}
