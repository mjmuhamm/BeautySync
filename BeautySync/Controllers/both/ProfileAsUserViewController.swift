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
    @IBOutlet weak var contentCollectionView: UICollectionView!

    var beauticianOrUser = ""
    var userId = ""
    
    var item: ServiceItems?
    var itemType = "hairCareItems"
    
    //Beautician
    private var items : [ServiceItems] = []
    var content: [VideoModel] = []
    
    // User
    var beauticians : [Beauticians] = []
    var likes : [ServiceItems] = []
    var reviews : [UserReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.register(UINib(nibName: "ServiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceItemReusableCell")
        serviceTableView.register(UINib(nibName: "UserItemTableViewCell", bundle: nil), forCellReuseIdentifier: "UserItemReusableCell")
        serviceTableView.register(UINib(nibName: "UserBeauticiansTableViewCell", bundle: nil), forCellReuseIdentifier: "UserBeauticiansReusableCell")
        serviceTableView.register(UINib(nibName: "UserReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReviewsReusableCell")
        
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        contentCollectionView.register(UINib(nibName: "BeauticianContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BeauticianContentCollectionViewReusableCell")
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        if item != nil {
            button1.isHidden = false
            button2.setTitle("Skin Care", for: .normal)
            button2.isUppercaseTitle = false
            button3.setTitle("Nail Care", for: .normal)
            button3.isUppercaseTitle = false
            button4.setTitle("Content", for: .normal)
            button4.isUppercaseTitle = false
            
            loadBeauticianInfo(userId: item!.beauticianImageId)
            loadBeauticianItems(itemType: itemType)
            self.userName.text = "\(item!.beauticianUsername)"
            if item!.beauticianUserImage != nil {
                self.userImage.image = item!.beauticianUserImage
            }
        } else {
            button1.isHidden = true
            button2.setTitleColor(UIColor.white, for: .normal)
            button2.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
            button2.setTitle("Beauticians", for: .normal)
            button2.isUppercaseTitle = false
            button3.setTitle("Likes", for: .normal)
            button3.isUppercaseTitle = false
            button4.setTitle("Reviews", for: .normal)
            button4.isUppercaseTitle = false
            loadUserInfo()
            loadBeauticians()
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
        contentCollectionView.isHidden = true
        serviceTableView.isHidden = false
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
        } else {
            itemType = "Beauticians"
            loadBeauticians()
        }
        contentCollectionView.isHidden = true
        serviceTableView.isHidden = false
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
        } else {
            itemType = "Likes"
            loadLikes()
        }
        contentCollectionView.isHidden = true
        serviceTableView.isHidden = false
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
            contentCollectionView.isHidden = false
            serviceTableView.isHidden = true
            loadContent()
        } else {
            itemType = "Reviews"
            loadReviews()
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
                            
                            if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let hashtags = data["hashtags"] as? [String], let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let beauticianPassion = data["beauticianPassion"] as? String {
                                
                                self.db.collection(itemType).document(doc.documentID).getDocument { document, error in
                                    if error == nil {
                                        if document != nil {
                                            let data = document!.data()
                                            
                                            if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? [Int] {
                                             
                                
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
                }
            }
    }
    
    private func loadContent() {
        print("userId \(userId)")
        db.collection("Beautician").document(userId).collection("Content").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let beauticianImageId = data["beauticianImageId"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let description = data["description"] as? String, let downloadUrl = data["downloadUrl"] as? String, let liked = data["liked"] as? [String] {
                            
                            self.db.collection("Content").document(doc.documentID).getDocument { document, error in
                                if error == nil {
                                    if document != nil {
                                        let data1 = document!.data()
                                        
                                        if let views = data1?["views"] as? Int {
                                         
                            let x = VideoModel(dataUri: downloadUrl, documentId: doc.documentID, userImageId: beauticianImageId, user: beauticianUsername, description: description, views: views, liked: liked, comments: 0, shared: 0, thumbNailUrl: "")
                            
                            if self.content.isEmpty {
                                self.content.append(x)
                                self.contentCollectionView.reloadData()
                                
                            } else {
                                let index = self.content.firstIndex { $0.documentId == doc.documentID as! String }
                                if index == nil {
                                    self.content.append(x)
                                    self.contentCollectionView.reloadData()
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
    
    
    //User
    private func loadUserInfo() {
        
        self.storage.reference().child("users/\(userId)/profileImage/\(userId).png").downloadURL { url, error in
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
        
        db.collection("User").document(userId).collection("PersonalInfo").getDocuments { documents, error in
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
                            self.passionStatement.text = "Interest: \(whatDoYouHopeToFind)"
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
        self.serviceTableView.reloadData()
        
        db.collection("User").document(userId).collection("Beauticians").getDocuments { documents, error in
            if error == nil
            {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let beauticianCity = data["beauticianCity"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let itemCount = data["itemCount"] as? Int {
                            
                            let x = Beauticians(beauticianCity: beauticianCity, beauticianImageId: beauticianImageId, beauticianPassion: beauticianPassion, beauticianState: beauticianState, beauticianUsername: beauticianUsername, itemCount: itemCount, documentId: doc.documentID)
                            
                            if self.beauticians.isEmpty {
                                self.beauticians.append(x)
                                self.serviceTableView.reloadData()
                            } else {
                                let index = self.beauticians.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.beauticians.append(x)
                                    self.serviceTableView.insertRows(at: [IndexPath(item: self.beauticians.count - 1, section: 0)], with: .fade)
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
        self.serviceTableView.reloadData()
        
        db.collection("User").document(userId).collection("Likes").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemType = data["itemType"] as? String, let itemTitle = data["itemTitle"] as? String, let itemDescription = data["itemDescription"] as? String, let itemPrice = data["itemPrice"] as? String, let imageCount = data["imageCount"] as? Int, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianPassion = data["beauticianPassion"] as? String, let beauticianCity = data["beauticianCity"] as? String, let beauticianState = data["beauticianState"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let hashtags = data["hashtags"] as? [String] {
                            
                            self.db.collection(itemType).document(doc.documentID).getDocument { document, error in
                                if error == nil {
                                    if document != nil {
                                        let data = document!.data()
                                        print("going through yes")
                                        
                                        if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? [Int] {
                                            
                                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: doc.documentID)
                                            
                                            if self.likes.isEmpty {
                                                self.likes.append(x)
                                                self.serviceTableView.reloadData()
                                            } else {
                                                let index = self.likes.firstIndex { $0.documentId == doc.documentID }
                                                if index == nil {
                                                    self.likes.append(x)
                                                    self.serviceTableView.insertRows(at: [IndexPath(item: self.likes.count - 1, section: 0)], with: .fade)
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
        self.serviceTableView.reloadData()
        
        db.collection("User").document(userId).collection("Reviews").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let date = data["date"] as? String, let expectations = data["expectations"] as? Int, let itemDescription = data["itemDescription"] as? String, let itemId = data["itemId"] as? String, let itemTitle = data["itemTitle"] as? String, let itemType = data["itemType"] as? String, let liked = data["liked"] as? [String], let quality = data["quality"] as? Int, let rating = data["rating"] as? Int, let recommend = data["recommend"] as? Int, let thoughts = data["thoughts"] as? String, let userImageId = data["userImageId"] as? String, let userName = data["userName"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let orderDate = data["orderDate"] as? String {
                            
                            let x = UserReview(date: date, expectations: expectations, quality: quality, rating: rating, recommend: recommend, thoughts: thoughts, itemDescription: itemDescription, itemId: itemId, itemTitle: itemTitle, itemType: itemType, userImageId: userImageId, userName: userName, liked: liked, beauticianUsername: beauticianUsername, beauticianImageId: beauticianImageId, orderDate: orderDate, documentId: doc.documentID)
                            
                            if self.reviews.isEmpty {
                                self.reviews.append(x)
                                self.serviceTableView.reloadData()
                            } else {
                                let index = self.reviews.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.reviews.append(x)
                                    self.serviceTableView.insertRows(at: [IndexPath(item: self.reviews.count - 1, section: 0)], with: .fade)
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
        } else if itemType == "Beauticians" {
            return beauticians.count
        } else if itemType == "Likes" {
            return likes.count
        } else if itemType == "Reviews" {
            return reviews.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if beauticianOrUser == "Beautician" && itemType != "contentItems" {
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
        } else if itemType == "Beauticians" {
            var cell = serviceTableView.dequeueReusableCell(withIdentifier: "UserBeauticiansReusableCell", for: indexPath) as! UserBeauticiansTableViewCell
            
            serviceTableView.rowHeight = 72
            
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
                    self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                    
                }
            }
            return cell
        } else if itemType == "Likes" {
            var cell = serviceTableView.dequeueReusableCell(withIdentifier: "UserItemReusableCell", for: indexPath) as! UserItemTableViewCell
            
            
            serviceTableView.rowHeight = 490
            
            var item = likes[indexPath.row]
            
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
                    self.serviceTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                    
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
        } else if itemType == "Reviews" {
            let cell = serviceTableView.dequeueReusableCell(withIdentifier: "UserReviewsReusableCell", for: indexPath) as! UserReviewsTableViewCell
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
            
            serviceTableView.rowHeight = 161
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
            
        }else {
            return UITableViewCell()
        }
    }
}

extension ProfileAsUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "BeauticianContentCollectionViewReusableCell", for: indexPath) as! BeauticianContentCollectionViewCell
        
        let content = content[indexPath.row]
        print("views \(content.views)")
        cell.viewText.text = "\(content.views)"
            cell.configure(model: content)
        
        cell.videoViewButtonTapped = {
            var cont : [VideoModel] = []
            cont.append(content)
            
            for i in 0..<self.content.count {
                if content.documentId != self.content[i].documentId {
                    cont.append(self.content[i])
                }
            }
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Feed") as? FeedViewController  {
                vc.beauticianOrFeed = "user"
                vc.content = cont
                vc.yes = "Yes"
                vc.index = indexPath.row
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (contentCollectionView.frame.size.width / 3) - 3, height: (contentCollectionView.frame.size.height / 3) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}
