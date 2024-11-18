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
    var reviews : [Reviews] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.register(UINib(nibName: "UserItemTableViewCell", bundle: nil), forCellReuseIdentifier: "UserItemReusableCell")
        userTableView.register(UINib(nibName: "UserBeauticiansTableViewCell", bundle: nil), forCellReuseIdentifier: "UserBeauticiansReusableCell")
        userTableView.register(UINib(nibName: "UserReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReviewsReusableCell")
        
        userTableView.delegate = self
        userTableView.dataSource = self
        loadInfo()
        
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
                            self.whatDoYouHopeToFind.text = "User Interest: \(whatDoYouHopeToFind)"
                        }
                    }
                }
            }
        }
    }
        
    private func loadOrders() {
        
        self.items.removeAll()
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
                                        
                                        if let liked = data!["liked"] as? [String], let itemOrders = data!["itemOrders"] as? Int, let itemRating = data!["itemRating"] as? Double {
                                            
                                            let x = ServiceItems(itemType: itemType, itemTitle: itemTitle, itemDescription: itemDescription, itemPrice: itemPrice, imageCount: imageCount, beauticianUsername: beauticianUsername, beauticianPassion: beauticianPassion, beauticianCity: beauticianCity, beauticianState: beauticianState, beauticianImageId: beauticianImageId, liked: liked, itemOrders: itemOrders, itemRating: itemRating, hashtags: hashtags, documentId: itemId)
                                            
                                            if self.items.isEmpty {
                                                self.items.append(x)
                                                self.userTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
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
        
    }
    
    private func loadLikes() {
        
    }
    
    private func loadReviews() {
        
    }
        
}

extension UserMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if itemType == "orders" {
            var cell = userTableView.dequeueReusableCell(withIdentifier: "UserItemReusableCell", for: indexPath) as! UserItemTableViewCell
            
            var item = items[indexPath.row]
            
            
            cell.itemTitle.text = item.itemTitle
            cell.itemDescription.text = item.itemDescription
            cell.itemPrice.text = "$\(item.itemPrice)"
            cell.itemLikes.text = "\(item.liked.count)"
            cell.itemOrders.text = "\(item.itemOrders)"
            cell.itemRating.text = "\(item.itemRating)"
            
            if item.liked.firstIndex(of: Auth.auth().currentUser!.uid) != nil {
                cell.itemLikeImage.image = UIImage(systemName: "heart.fill")
            } else {
                cell.itemLikeImage.image = UIImage(systemName: "heart")
            }

            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
