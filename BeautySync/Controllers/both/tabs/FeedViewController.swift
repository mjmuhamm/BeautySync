//
//  FeedViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/20/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import AVFoundation

class FeedViewController: UIViewController {

    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    var content : [VideoModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var beauticianOrFeed = ""
    var yes = ""
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeedCollectionViewReusableCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        loadContent()
    }
    

    private func loadContent() {
        db.collection("Content").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let beauticianImageId = data["beauticianImageId"] as? String, let beauticianUsername = data["beauticianUsername"] as? String, let description = data["description"] as? String, let downloadUrl = data["downloadUrl"] as? String, let liked = data["liked"] as? [String], let views = data["views"] as? Int {
                            
                            let x = VideoModel(dataUri: downloadUrl, documentId: doc.documentID, userImageId: beauticianImageId, user: beauticianUsername, description: description, views: views, liked: liked, comments: 0, shared: 0, thumbNailUrl: "")
                            
                            if self.content.isEmpty {
                                self.content.append(x)
                                self.content.shuffle()
                                self.collectionView.reloadData()
                                
                            } else {
                                let index = self.content.firstIndex { $0.documentId == doc.documentID as! String }
                                if index == nil {
                                    self.content.append(x)
                                    self.content.shuffle()
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func deleteContent(id: String) {
        
        
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: (self.view.frame.width), height: 70))
        toastLabel.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 4
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastCompletion(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: (self.view.frame.width), height: 70))
        toastLabel.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 4
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            self.dismiss(animated: true)
            toastLabel.removeFromSuperview()
        })
    }
    

}

extension FeedViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewReusableCell", for: indexPath) as! FeedCollectionViewCell
        
        var model = content[indexPath.row]
        
        
        cell.configure(model: model)
        cell.likeText.text = "\(model.liked.count)"
        cell.commentText.text = "\(model.comments)"
        cell.shareText.text = "\(model.shared)"
        cell.userName.text = model.user
        cell.videoDescription.text = "\(model.description) \(model.description) \(model.description)"
        
        if (model.liked.contains(Auth.auth().currentUser!.uid)) {
            cell.likeImage.image = UIImage(systemName: "heart.fill")
        } else {
            cell.likeImage.image = UIImage(systemName: "heart")
        }
        
        cell.likeButtonTapped = {
            if cell.likeImage.image == UIImage(systemName: "heart") {
                self.db.collection("Content").document(model.documentId).updateData(["liked" : FieldValue.arrayUnion(["\(Auth.auth().currentUser!.uid)"])])
                model.liked.append(Auth.auth().currentUser!.uid)
                cell.likeText.text = "\(Int(cell.likeText.text!)! + 1)"
                cell.likeImage.image = UIImage(systemName: "heart.fill")
                
            } else {
                self.db.collection("Content").document(model.documentId).updateData(["liked" : FieldValue.arrayRemove(["\(Auth.auth().currentUser!.uid)"])])
                if let index = model.liked.firstIndex(where: { $0 == "\(Auth.auth().currentUser!.uid)" }) {
                    model.liked.remove(at: index)
                }
                
                model.liked.append(Auth.auth().currentUser!.email!)
                cell.likeText.text = "\(Int(cell.likeText.text!)! - 1)"
                cell.likeImage.image = UIImage(systemName: "heart")
            }
        }
        
        
        if beauticianOrFeed != "" {
            cell.backButton.isHidden = false
            if beauticianOrFeed == "chef" {
                print("feed happening 212")
                cell.deleteButton.isHidden = false
            }
        } else {
            cell.backButton.isHidden = true
            cell.deleteButton.isHidden = true
        }
        
        
        cell.backButtonTapped = {
            self.dismiss(animated: true)
        }
        
        if yes != "" {
            cell.deleteButton.isHidden = false
        }
        cell.deleteButtonTapped = {
            
            let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
                self.deleteContent(id: model.documentId)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        cell.playPauseButtonTapped = {
            cell.playPauseButton.isSelected = !cell.playPauseButton.isSelected
            if (cell.playPauseButton.isSelected) {
                cell.player.pause()
                cell.playImage.isHidden = false
            } else {
                cell.player.play()
                cell.playImage.isHidden = true
            }
        }
        
        cell.commentButtonTapped = {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Comments") as? CommentsViewController  {
//                vc.videoId = model.id
//                self.present(vc, animated: true, completion: nil)
//            }
        }
        
        
        
        return cell
    }
//
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FeedCollectionViewCell {
            cell.playImage.isHidden = true
            cell.player?.seek(to: CMTime.zero)
            cell.player?.play()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FeedCollectionViewCell {
            cell.player?.pause()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
}
