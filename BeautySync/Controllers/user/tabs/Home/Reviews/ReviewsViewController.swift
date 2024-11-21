//
//  ReviewsViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/21/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ReviewsViewController: UIViewController {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var reviews: [UserReview] = []
    var item : ServiceItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsReusableCell")
        loadReviews()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    private func loadReviews() {
        db.collection(item!.itemType).document(item!.documentId).collection("Reviews").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let date = data["date"] as? String, let expectations = data["expectations"] as? Int, let itemDescription = data["itemDescription"] as? String, let itemId = data["itemId"] as? String, let itemTitle = data["itemTitle"] as? String, let itemType = data["itemType"] as? String, let liked = data["liked"] as? [String], let quality = data["quality"] as? Int, let rating = data["rating"] as? Int, let recommend = data["recommend"] as? Int, let thoughts = data["thoughts"] as? String, let userImageId = data["userImageId"] as? String, let userName = data["userName"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let beauticianImageId = data["beauticianImageId"] as? String, let orderDate = data["orderDate"] as? String {
                            
                            let x = UserReview(date: date, expectations: expectations, quality: quality, rating: rating, recommend: recommend, thoughts: thoughts, itemDescription: itemDescription, itemId: itemId, itemTitle: itemTitle, itemType: itemType, userImageId: userImageId, userName: userName, liked: liked, beauticianUsername: beauticianUsername, beauticianImageId: beauticianImageId, orderDate: orderDate, documentId: doc.documentID)
                            
                            if self.reviews.isEmpty {
                                self.reviews.append(x)
                                self.reviewTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.reviews.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.reviews.append(x)
                                    self.reviewTableView.insertRows(at: [IndexPath(item: self.reviews.count - 1, section: 0)], with: .fade)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

}

extension ReviewsViewController :  UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewsReusableCell", for: indexPath) as! ReviewsTableViewCell
        var review = reviews[indexPath.row]
        
        var thoughts = ""
        if review.thoughts == "" {
            thoughts = "\(review.userName) has not disclosed any external thoughts in this review."
        } else {
            thoughts = review.thoughts
        }
        cell.itemThoughts.text = thoughts
        cell.orderDate.text = "Reviewed: \(review.date)"
        cell.expectationsLabel.text = "\(review.expectations)"
        cell.qualityLabel.text = "\(review.quality)"
        cell.ratingLabel.text = "\(review.rating)"
        
        reviewTableView.rowHeight = 133
        let beauticianRef = storage.reference()
        
        DispatchQueue.main.async {
            beauticianRef.child("users/\(review.userImageId)/profileImage/\(review.userImageId).png").getData(maxSize: 15 * 1024 * 1024) { data, error in
                if error == nil {
                    cell.userImage.image = UIImage(data: data!)!
                }}
            
        }
        
        if review.recommend == 1 {
            cell.recommendLabel.text = "Yes"
        } else {
            cell.recommendLabel.text = "No"
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
                vc.beauticianOrUser = "user"
                vc.userId = review.userImageId
                vc.itemType = "Beauticians"
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        
        
        return cell
    }
}
