//
//  UserMeViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/9/24.
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

class UserMeViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationBell: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var whatDoYouHopeToFind: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var ordersButton: MDCButton!
    @IBOutlet weak var beauticiansButton: MDCButton!
    @IBOutlet weak var likesButton: MDCButton!
    @IBOutlet weak var reviewsButton: MDCButton!
    
    @IBOutlet weak var userTableView: UITableView!
    
    var itemType = "orders"
    var items : [ServiceItems] = []
    var beauticians : [Beauticians] = []
    var reviews : [UserReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.register(UINib(nibName: "UserItemTableViewCell", bundle: nil), forCellReuseIdentifier: "UserItemReusableCell")
        userTableView.register(UINib(nibName: "UserBeauticiansTableViewCell", bundle: nil), forCellReuseIdentifier: "UserBeauticiansReusableCell")
        userTableView.register(UINib(nibName: "UserReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReviewsReusableCell")
        
        userTableView.delegate = self
        userTableView.dataSource = self
        loadInfo()
        loadOrders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
    }
    
    @IBAction func notificationButtonPressed(_ sender: Any) {
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountSettings") as? UserAccountSettingsViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
        itemType = "orders"
        loadOrders()
        ordersButton.setTitleColor(UIColor.white, for: .normal)
        ordersButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func beauticiansButtonPressed(_ sender: Any) {
        itemType = "beauticians"
        loadBeauticians()
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.setTitleColor(UIColor.white, for: .normal)
        beauticiansButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func likesButtonPressed(_ sender: Any) {
        itemType = "likes"
        loadLikes()
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.setTitleColor(UIColor.white, for: .normal)
        likesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        reviewsButton.backgroundColor = UIColor.white
        reviewsButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func reviewsButtonPressed(_ sender: Any) {
        itemType = "reviews"
        loadReviews()
        ordersButton.backgroundColor = UIColor.white
        ordersButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        beauticiansButton.backgroundColor = UIColor.white
        beauticiansButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        likesButton.backgroundColor = UIColor.white
        likesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        reviewsButton.setTitleColor(UIColor.white, for: .normal)
        reviewsButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    private func loadInfo() {
        
        self.storage.reference().child("users/\(Auth.auth().currentUser!.uid)/profileImage/\(Auth.auth().currentUser!.uid).png").downloadURL { url, error in
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
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let userName = data["userName"] as? String, let local = data["local"] as? Int, let region = data["region"] as? Int, let nation = data["nation"] as? Int, let whatDoYouHopeToFind = data["whatDoYouHopeToFind"] as? String, let city = data["city"] as? String, let state = data["state"] as? String {
                            
                            if local == 1 {
                                self.location.text = "Location: \(city) \(state)"
                            } else if region == 1 {
                                self.location.text = "Location: \(state)"
                            } else if nation == 1 {
                                self.location.text = "Location: Nationwide"
                            }
                            
                            self.userName.text = "@\(userName)"
                            self.whatDoYouHopeToFind.text = "Interest: \(whatDoYouHopeToFind)"
                        }
                    }
                }
            }
        }
    }
        
    private func loadOrders() {
        
        self.items.removeAll()
        self.beauticians.removeAll()
        self.userTableView.reloadData()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let hashtags = data["hashtags"] as? [String], let itemId = data["itemId"] as? String {
                            
                            self.db.collection(itemType).document(itemId).getDocument { document, error in
                                if error == nil {
                                    if document != nil {
                                        let data = document!.data()
                                        
                                        if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? [Int] {
                                            
                                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: itemId)
                                            
                                            if self.items.isEmpty {
                                                self.items.append(x)
                                                self.userTableView.reloadData()
                                            } else {
                                                let index = self.items.firstIndex { $0.documentId == doc.documentID }
                                                if index == nil {
                                                    self.items.append(x)
                                                    self.userTableView.insertRows(at: [IndexPath(item: self.items.count - 1, section: 0)], with: .fade)
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
    
    private func loadBeauticians() {
        
        self.items.removeAll()
        self.beauticians.removeAll()
        self.reviews.removeAll()
        self.userTableView.reloadData()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").getDocuments { documents, error in
            if error == nil
            {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let beauticianCity = data["beauticianCity"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let itemCount = data["itemCount"] as? Int {
                            
                            let x = Beauticians(beauticianCity: beauticianCity, beauticianImageId: beauticianImageId, beauticianPassion: beauticianPassion, beauticianState: beauticianState, beauticianUsername: beauticianUsername, itemCount: itemCount, documentId: doc.documentID)
                            
                            if self.beauticians.isEmpty {
                                self.beauticians.append(x)
                                self.userTableView.reloadData()
                            } else {
                                let index = self.beauticians.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.beauticians.append(x)
                                    self.userTableView.insertRows(at: [IndexPath(item: self.beauticians.count - 1, section: 0)], with: .fade)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    private func loadLikes() {
        self.items.removeAll()
        self.beauticians.removeAll()
        self.reviews.removeAll()
        self.userTableView.reloadData()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Likes").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let hashtags = data["hashtags"] as? [String] {
                            
                            self.db.collection(itemType).document(doc.documentID).getDocument { document, error in
                                if error == nil {
                                    if document != nil {
                                        let data = document!.data()
                                        
                                        if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? [Int] {
                                            
                                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID)
                                            
                                            if self.items.isEmpty {
                                                self.items.append(x)
                                                self.userTableView.reloadData()
                                            } else {
                                                let index = self.items.firstIndex { $0.documentId == doc.documentID }
                                                if index == nil {
                                                    self.items.append(x)
                                                    self.userTableView.insertRows(at: [IndexPath(item: self.items.count - 1, section: 0)], with: .fade)
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
    
    private func loadReviews() {
        self.items.removeAll()
        self.beauticians.removeAll()
        self.reviews.removeAll()
        self.userTableView.reloadData()
        
        db.collection("User").document(Auth.auth().currentUser!.uid).collection("Reviews").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let date = data["date"] as? String, let expectations = data["expectations"] as? Int, let itemDescription = data["itemDescription"] as? String, let itemId = data["itemId"] as? String, let itemTitle = data["itemTitle"] as? String, let itemType = data["itemType"] as? String, let liked = data["liked"] as? [String], let quality = data["quality"] as? Int, let rating = data["rating"] as? Int, let recommend = data["recommend"] as? Int, let thoughts = data["thoughts"] as? String, let userImageId = data["userImageId"] as? String, let userName = data["userName"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let orderDate = data["orderDate"] as? String {
                            
                            let x = UserReview(date: date, expectations: expectations, quality: quality, rating: rating, recommend: recommend, thoughts: thoughts, itemDescription: itemDescription, itemId: itemId, itemTitle: itemTitle, itemType: itemType, userImageId: userImageId, userName: userName, liked: liked, beauticianUsername: beauticianUsername, beauticianImageId: beauticianImageId, orderDate: orderDate, documentId: doc.documentID)
                            
                            if self.reviews.isEmpty {
                                self.reviews.append(x)
                                self.userTableView.reloadData()
                            } else {
                                let index = self.reviews.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.reviews.append(x)
                                    self.userTableView.insertRows(at: [IndexPath(item: self.reviews.count - 1, section: 0)], with: .fade)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
        
}

extension UserMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemType == "orders" || itemType == "likes" {
            return items.count
        }  else if itemType == "beauticians" {
            return beauticians.count
        } else if itemType == "reviews" {
            return reviews.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if itemType == "orders" {
            var cell = userTableView.dequeueReusableCell(withIdentifier: "UserItemReusableCell", for: indexPath) as! UserItemTableViewCell
            
            userTableView.rowHeight = 490
            
            var item = items[indexPath.row]
            
            cell.itemTitle.text = item.itemTitle
            cell.itemDescription.text = item.itemDescription
            cell.itemPrice.text = "$\(item.itemPrice)"
            cell.itemLikes.text = "\(item.liked.count)"
            cell.itemOrders.text = "\(item.itemOrders)"
            cell.itemRating.text = "\(item.itemRating)"
        
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
            
            if item.liked.firstIndex(of: Auth.auth().currentUser!.uid) != nil {
                cell.itemLikeImage.image = UIImage(systemName: "heart.fill")
            } else {
                cell.itemLikeImage.image = UIImage(systemName: "heart")
            }
            
            cell.itemOrderButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetails") as? OrderDetailsViewController {
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
            
            
            cell.itemDetailButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController {
                    vc.item = item
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            cell.itemLikeButtonTapped = {
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
        } else if itemType == "beauticians" {
            var cell = userTableView.dequeueReusableCell(withIdentifier: "UserBeauticiansReusableCell", for: indexPath) as! UserBeauticiansTableViewCell
            
            userTableView.rowHeight = 72
            
            var item = beauticians[indexPath.row]
            
            let storageRef = storage.reference()
            storageRef.child("beauticians/\(item.beauticianImageId)/profileImage/\(item.beauticianImageId).png").downloadURL { itemUrl, error in
                if itemUrl != nil {
                    URLSession.shared.dataTask(with: itemUrl!) { (data, response, error) in
                        // Error handling...
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            cell.userImage.image = UIImage(data: imageData)!
//                            item.beauticianUserImage = UIImage(data: imageData)!
                        }
                    }.resume()
                }
            }
            
            cell.beauticianPassionStatement.text = "\(item.beauticianPassion)"
            cell.location.text = "Location: \(item.beauticianCity), \(item.beauticianState)"
            
            cell.userImageButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAsUser") as? ProfileAsUserViewController {
                    vc.userId = item.beauticianImageId
                    vc.beauticianOrUser = "Beautician"
                    vc.item = ServiceItems(itemType: "", itemTitle: "", itemDescription: "", itemPrice: "", imageCount: 0, beauticianUsername: item.beauticianUsername, beauticianPassion: item.beauticianPassion, beauticianCity: item.beauticianCity, beauticianState: item.beauticianState, beauticianImageId: item.beauticianImageId, liked: [], itemOrders: 0, itemRating: [], hashtags: [], documentId: item.documentId)
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            cell.userLikeButtonTapped = {
                print("documentId \(item.documentId)")
                self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Beauticians").document(item.documentId).delete()
                if let index = self.beauticians.firstIndex(where: { $0.documentId == item.documentId }) {
                    self.beauticians.remove(at: index)
                    self.userTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                    
                }
            }
            
            return cell
        } else if itemType == "likes" { 
            var cell = userTableView.dequeueReusableCell(withIdentifier: "UserItemReusableCell", for: indexPath) as! UserItemTableViewCell
            
            userTableView.rowHeight = 490
            
            var item = items[indexPath.row]
            
            cell.itemTitle.text = item.itemTitle
            cell.itemDescription.text = item.itemDescription
            cell.itemPrice.text = "$\(item.itemPrice)"
            cell.itemLikes.text = "\(item.liked.count)"
            cell.itemOrders.text = "\(item.itemOrders)"
            cell.itemRating.text = "\(item.itemRating)"
            
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
            
            if item.liked.firstIndex(of: Auth.auth().currentUser!.uid) != nil {
                cell.itemLikeImage.image = UIImage(systemName: "heart.fill")
            } else {
                cell.itemLikeImage.image = UIImage(systemName: "heart")
            }
            
            cell.itemOrderButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetails") as? OrderDetailsViewController {
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
            
            
            cell.itemDetailButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController {
                    vc.item = item
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            cell.itemLikeButtonTapped = {
                    self.db.collection(item.itemType).document(item.documentId).updateData(["liked" : FieldValue.arrayRemove(["\(Auth.auth().currentUser!.uid)"])])
                    cell.itemLikes.text = "\(Int(cell.itemLikes.text!)! - 1)"
                
                if let index = self.items.firstIndex(where: { $0.documentId == item.documentId }) {
                    self.items.remove(at: index)
                    self.userTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                    
                }
                
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
            
            
            return cell
        } else if itemType == "reviews" {
            let cell = userTableView.dequeueReusableCell(withIdentifier: "UserReviewsReusableCell", for: indexPath) as! UserReviewsTableViewCell
            var review = reviews[indexPath.row]
            
            var thoughts = ""
            if review.thoughts == "" {
                thoughts = "\(review.userName) has not disclosed any external thoughts in this review."
            } else {
                thoughts = review.thoughts
            }
            
            var itemType1 = ""
            if review.itemType == "hairCareItems" {
                itemType1 = "Hair Care"
            } else if review.itemType == "skinCareItem" {
                itemType1 = "Skin Care"
            } else if review.itemType == "nailCareItem" {
                itemType1 = "Nail Care"
            }
            cell.itemTypeAndTitle.text = "\(itemType1) | \(review.itemTitle)"
            cell.beautician.text = "Beautician: \(review.beauticianUsername)"
            cell.userThoughts.text = thoughts
            cell.orderDate.text = "Ordered: \(review.orderDate)"
            cell.expectations.text = "\(review.expectations)"
            cell.quality.text = "\(review.quality)"
            cell.beauticianRating.text = "\(review.rating)"
            
            userTableView.rowHeight = 161
            let beauticianRef = storage.reference()
            
            DispatchQueue.main.async {
                beauticianRef.child("users/\(review.userImageId)/profileImage/\(review.userImageId).png").getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if error == nil {
                        cell.userImage.image = UIImage(data: data!)!
                    }}
                
            }
            
            if review.recommend == 1 {
                cell.doesTheUserRecommend.text = "Yes"
            } else {
                cell.doesTheUserRecommend.text = "No"
            }
            cell.userLikes.text = "\(review.liked.count)"
            if let index = review.liked.firstIndex(where: { $0 == Auth.auth().currentUser!.uid }) {
                cell.userLikeImage.image = UIImage(systemName: "heart.fill")
            }
            
            cell.userLikeButtonTapped = {
                
                if cell.userLikeImage.image == UIImage(systemName: "heart") {
                    cell.userLikeImage.image = UIImage(systemName: "heart.fill")
                    cell.userLikes.text = "\(Int(cell.userLikes.text!)! + 1)"
                    self.db.collection(review.itemType).document(review.itemId).collection("Reviews").document(review.documentId).updateData(["liked" : FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"])])
                    
                    
                    
                } else {
                    cell.userLikeImage.image = UIImage(systemName: "heart")
                    self.db.collection(review.itemType).document(review.itemId).collection("Reviews").document(review.documentId).updateData(["liked" : FieldValue.arrayRemove(["\(Auth.auth().currentUser!.uid)"])])
                    cell.userLikes.text = "\(Int(cell.userLikes.text!)! - 1)"
                    
                }
                
                
            }
            
            cell.userImageButtonTapped = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAsUser") as? ProfileAsUserViewController {
                    vc.userId = review.beauticianImageId
                    vc.beauticianOrUser = "Beautician"
                    vc.item = ServiceItems(itemType: review.itemType, itemTitle: review.itemTitle, itemDescription: review.itemDescription, itemPrice: "", imageCount: 0, beauticianUsername: review.beauticianUsername, beauticianPassion: "", beauticianCity: "", beauticianState: "", beauticianImageId: review.beauticianImageId, liked: [], itemOrders: 0, itemRating: [], hashtags: [], documentId: review.itemId)
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            
            
            
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}
