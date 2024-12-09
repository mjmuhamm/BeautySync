//
//  SearchViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 12/9/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SearchViewController: UIViewController, UISearchResultsUpdating {

    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var data : [Search] = []
    private var searchResults : [Search] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchReusableCell")

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.autocapitalizationType = .none
    }
    
    func updateSearchResults(for searchController: UISearchController) {
     
        guard let text = searchController.searchBar.text else {
            return
        }
        searchResults.removeAll()
        for string in data {
            if string.userFullName.starts(with: text) || string.userName.starts(with: text) {
                searchResults.append(string)
                tableView.reloadData()
            }
        }
        setupData()
        print("text \(text)")
        }
    
    private var count = 0
    private func setupData() {
        let storageRef = storage.reference()
        
        db.collection("Usernames").getDocuments { documents, error in
            if error == nil {
                if self.data.count != documents?.documents.count {
                    for doc in documents!.documents {
                        let data = doc.data()
                        self.count = documents!.documents.count
                        if let username = data["userName"] as? String, let fullName = data["fullName"] as? String, let email = data["email"] as? String, let beauticianOrUser = data["beauticianOrUser"] as? String {
                            var beauticianOrUser1 = ""
                            if beauticianOrUser == "User" { beauticianOrUser1 = "users" } else { beauticianOrUser1 = "beauticians" }
                            
                            storageRef.child("\(beauticianOrUser1)/\(doc.documentID)/profileImage/\(doc.documentID).png").downloadURL { imageUrl, error in
                                if imageUrl != nil {
                                    URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                                        // Error handling...
                                        guard let imageData = data else { return }
                                        
                                        print("happening itemdata")
                                        DispatchQueue.main.async {
                                            
                                            if self.data.isEmpty {
                                                self.data.append(Search(userName: username, userEmail: email, userFullName: fullName, userImage: UIImage(data: imageData)!, pictureId: doc.documentID, beauticianOrUser: beauticianOrUser))
                                            } else {
                                                let index = self.data.firstIndex { $0.pictureId == doc.documentID }
                                                   if index == nil {
                                                       self.data.append(Search(userName: username, userEmail: email, userFullName: fullName, userImage: UIImage(data: imageData)!, pictureId: doc.documentID, beauticianOrUser: beauticianOrUser))
                                                            
                                                }
                                            }
                                        }
                                    }.resume()
                                }
                                
                            }
                           
                        }
                    }
                }
            }
        }
    }
}

extension SearchViewController :  UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchResults.isEmpty {
            return searchResults.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchReusableCell", for: indexPath) as! SearchTableViewCell
        var user = data[indexPath.row]
        if !searchResults.isEmpty {
            user = searchResults[indexPath.row]
            cell.userName.text = searchResults[indexPath.row].userName
            cell.userFullName.text = searchResults[indexPath.row].userFullName
            cell.userImage.image = searchResults[indexPath.row].userImage
        }
        
        tableView.rowHeight = 79
        
        var beauticianOrUser = ""
        if user.beauticianOrUser == "User" { beauticianOrUser = "users" } else { beauticianOrUser = "beauticians" }
        
        let storageRef = storage.reference()
        print("\(user.userEmail)")
        print("\(user.pictureId)")
        
        
        
        
        cell.userImageButtonTapped = {
            print("beauticianOrUser \(user.beauticianOrUser)")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileAsUser") as? ProfileAsUserViewController  {
                vc.userId = user.pictureId
                vc.beauticianOrUser = "\(user.beauticianOrUser)"
                if user.beauticianOrUser == "Beautician" {
                    vc.item = ServiceItems(itemType: "", itemTitle: "", itemDescription: "", itemPrice: "", imageCount: 0, beauticianUsername: user.userName, beauticianUserImage: user.userImage, beauticianPassion: "", beauticianCity: "", beauticianState: "", beauticianImageId: user.pictureId, liked: [], itemOrders: 0, itemRating: [], hashtags: [], documentId: user.pictureId)
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        return cell
        
    }
}
