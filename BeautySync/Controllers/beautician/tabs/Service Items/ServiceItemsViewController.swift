//
//  ServiceItemsViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/7/24.
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

class ServiceItemsViewController: UIViewController {
    

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var serviceItemLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var cancelButton: MDCButton!
    @IBOutlet weak var addButton: MDCButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemPrice: UITextField!
    
    //Hashtag
    @IBOutlet weak var hashtagText: UITextField!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var hashtagAddButton: MDCButton!
    @IBOutlet weak var hashtagDeleteButton: MDCButton!
    var hashtags : [String] = []
    
    var item : ServiceItems?
    var itemType = ""
    var newOrEdit = "new"
    var serviceItemId = UUID().uuidString
    
    //Image
    var imgArr : [ServiceImage] = []
    var imgArrData: [Data] = []
    var currentIndex = 0
    
    //Beautician Info
    var beauticianUsername = ""
    var beauticianPassion = ""
    var beauticianCity = ""
    var beauticianState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        self.serviceItemLabel.text = "\(itemType)"
        
        self.sliderCollectionView.delegate = self
        self.sliderCollectionView.dataSource = self
        self.pageControl.currentPage = 0
        
        if newOrEdit == "edit" {
            self.deleteButton.isHidden = false
            self.itemTitle.text = item!.itemTitle
            self.itemDescription.text = item!.itemDescription
            self.itemPrice.text = item!.itemPrice
            self.hashtags = item!.hashtags
            for i in 0..<item!.hashtags.count {
                if i == 0 {
                    self.hashtagLabel.text = item!.hashtags[0]
                } else {
                    self.hashtagLabel.text = "\(self.hashtagLabel.text!), \(self.item!.hashtags[i])"
                }
                if item!.hashtags.count > 0 {
                    self.hashtagDeleteButton.isHidden = false
                }
                beauticianUsername = item!.beauticianUsername
                beauticianPassion = item!.beauticianPassion
                beauticianCity = item!.beauticianCity
                beauticianState = item!.beauticianState
                serviceItemId = item!.documentId
            }
            var item1 = ""
            if itemType == "Hair Item" { item1 = "hairItems" } else if itemType == "Makeup Item" { item1 = "makeupItems" } else if itemType == "Lash Item" { item1 = "lashItems" }
            for i in 0..<item!.imageCount {
                print("path123456 \(item1)/\(Auth.auth().currentUser!.uid)/\(serviceItemId)/\(serviceItemId)\(i).png")
                var path = "\(item1)/\(Auth.auth().currentUser!.uid)/\(serviceItemId)/\(serviceItemId)\(i).png"
                storage.reference().child(path).downloadURL { url, error in
                    if error == nil {
                        if url != nil {
                            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                                // Error handling...
                                guard let imageData = data else { return }
                                
                                DispatchQueue.main.async {
                                    self.imgArr.append(ServiceImage(image: UIImage(data: imageData)!, imgPath: path))
                                    self.imgArrData.append(UIImage(data: imageData)!.pngData()!)
                                    self.cancelButton.isHidden = false
                                    self.pageControl.numberOfPages = self.imgArr.count
                                    self.sliderCollectionView.reloadData()
                                }
                            }.resume()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  
    @IBAction func deleteButtonPressed(_ sender: Any) {
        var item1 = ""
        if itemType == "Hair Item" { item1 = "hairItems" } else if itemType == "Makeup Item" { item1 = "makeupItems" } else if itemType == "Lash Item" { item1 = "lashItems" }
        let storageRef = self.storage.reference()
        
        let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(item1).document(self.serviceItemId).delete()
                self.db.collection(item1).document(self.serviceItemId).delete()
                
            for i in 0..<self.item!.imageCount {
                storageRef.child("\(item1)/\(Auth.auth().currentUser!.uid)/\(self.serviceItemId)/\(self.serviceItemId)\(i).png").delete { error in
                    
                }
            }
                    
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                    self.present(vc, animated: true, completion: nil)
                }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        var item1 = ""
        if itemType == "Hair Item" { item1 = "hairItems" } else if itemType == "Makeup Item" { item1 = "makeupItems" } else if itemType == "Lash Item" { item1 = "lashItems" }
        
        if imgArr.count > 0 {
            if newOrEdit == "edit" {
                
                let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
                    let storageRef = self.storage.reference()
                    let renewRef = self.storage.reference()
                    var path = self.imgArr[self.currentIndex].imgPath
                    
                    for i in 0..<self.imgArr.count {
                        Task {
                            try? await storageRef.child(path).delete()
                        }
                        
                    }
                    self.imgArr.remove(at: self.currentIndex)
                    self.imgArrData.remove(at: self.currentIndex)
                    if self.imgArr.count == 0 {
                        self.cancelButton.isHidden = true
                    }
                    self.pageControl.numberOfPages = self.imgArr.count
                    self.sliderCollectionView.reloadData()
                    
                    for i in 0..<self.imgArr.count {
                        renewRef.child("\(item1)/\(Auth.auth().currentUser!.uid)/\(self.serviceItemId)/\(self.serviceItemId)\(i).png").putData(self.imgArrData[i])
                    }
                    let data: [String: Any] = ["imageCount" : self.imgArr.count]
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(item1).document(self.serviceItemId).updateData(data)
                    self.db.collection(item1).document(self.serviceItemId).updateData(data)
                    self.showToast(message: "Image deleted.", font: .systemFont(ofSize: 12))
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (handler) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                imgArr.remove(at: currentIndex)
                imgArrData.remove(at: currentIndex)
                if self.imgArr.count == 0 {
                    self.cancelButton.isHidden = true
                }
                self.pageControl.numberOfPages = imgArr.count
                self.sliderCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (handler) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let image = UIImagePickerController()
                image.allowsEditing = true
                image.sourceType = .camera
                image.delegate = self
                //                image.mediaTypes = [UTType.image.identifier]
                self.present(image, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let image = UIImagePickerController()
                image.allowsEditing = true
                image.delegate = self
                self.present(image, animated: true, completion: nil)
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (handler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func hashtagAddButton(_ sender: Any) {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if hashtagText.text == "" || hashtagText.text!.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            self.showToast(message: "Please enter a hashtag item with no special characters: For Example: natural.", font: .systemFont(ofSize: 12))
        } else {
            if hashtagLabel.text == "" {
                hashtagLabel.text = "#\(hashtagText.text!)"
            } else {
                hashtagLabel.text = "\(hashtagLabel.text!), #\(hashtagText.text!)"
            }
            hashtags.append("#\(hashtagText.text!)")
            hashtagText.text = ""
            hashtagDeleteButton.isHidden = false
        }
    }
    
    @IBAction func hashtagDeleteButton(_ sender: Any) {
        hashtagDeleteButton.isHidden = true
        hashtags.removeAll()
        hashtagLabel.text = ""
        hashtagText.text = ""
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var item = ""
        if self.itemType == "Hair Item" {
            item = "hairItems"
        } else if self.itemType == "Makeup Item" {
            item = "makeupItems"
        } else if self.itemType == "Lash Item" {
            item = "lashItems"
        }
        
        if itemTitle.text == "" {
            self.showToast(message: "Please enter an item title.", font: .systemFont(ofSize: 12))
        } else if imgArr.count == 0 {
            self.showToast(message: "Please select at least one image.", font: .systemFont(ofSize: 12))
        } else if itemDescription.text == "" {
            self.showToast(message: "Please enter an item description.", font: .systemFont(ofSize: 12))
        } else if itemPrice.text == "" || (Int(itemPrice.text!) == nil && Double(itemPrice.text!) == nil) {
            self.showToast(message: "Please enter an item price like so: 54.51.", font: .systemFont(ofSize: 12))
        } else {
            
            let data : [String: Any] = ["itemType" :  item, "itemTitle" : self.itemTitle.text!, "itemDescription" : self.itemDescription.text!, "itemPrice" : itemPrice.text!, "imageCount" : self.imgArr.count, "beauticianUsername" : "\(self.beauticianUsername)", "beauticianPassion" : self.beauticianPassion, "beauticianCity" : self.beauticianCity, "beauticianState": self.beauticianState, "beauticianImageId" : Auth.auth().currentUser!.uid, "liked" : [], "itemOrders" : 0, "itemRating" : 0, "hashtags" : hashtags]
            
            if newOrEdit == "new" {
                self.db.collection("Beautician").document("\(Auth.auth().currentUser!.uid)").collection(item).document(serviceItemId).setData(data)
                self.db.collection("\(item)").document("\(serviceItemId)").setData(data)
                let storageRef = storage.reference()
                for i in 0..<imgArr.count {
                    storageRef.child("\(item)/\(Auth.auth().currentUser!.uid)/\(self.serviceItemId)/\(self.serviceItemId)\(i).png").putData(self.imgArrData[i]) { data, error in
                        if error == nil {
                            if i == self.imgArr.count-1 {
                                self.activityIndicator.isHidden = true
                                self.showToastCompletion(message: "Item Saved.", font: .systemFont(ofSize: 12))
                            }
                        }
                    }
                }
            } else {
                self.db.collection("Beautician").document("\(Auth.auth().currentUser!.uid)").collection(item).document(serviceItemId).updateData(data)
                self.db.collection("\(item)").document("\(serviceItemId)").updateData(data)
                self.showToastCompletion(message: "Item Updated.", font: .systemFont(ofSize: 12))
            }
        }
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
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension ServiceItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var item = ""
        if self.itemType == "Hair Item" {
            item = "hairItems"
        } else if self.itemType == "Makeup Item" {
            item = "makeupItems"
        } else if self.itemType == "Lash Item" {
            item = "lashItems"
        }
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imgArr.append(ServiceImage(image: image, imgPath: ""))
        self.imgArrData.append(image.pngData()!)
        self.cancelButton.isHidden = false
        self.pageControl.numberOfPages = self.imgArr.count
        var path = "\(item)/\(Auth.auth().currentUser!.uid)/\(self.serviceItemId)/\(self.serviceItemId)\(self.imgArr.count - 1).png"
        if newOrEdit == "edit" {
            let storageRef = self.storage.reference()
            storageRef.child(path).putData(image.pngData()!)
            
            let data: [String: Any] = ["imageCount" : self.imgArr.count]
            self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(item).document(self.serviceItemId).updateData(data)
            self.db.collection(item).document(self.serviceItemId).updateData(data)
            self.showToast(message: "Image Added.", font: .systemFont(ofSize: 12))
        }
        self.sliderCollectionView.reloadData()
//        imageView.image = image
        print("image arr count\(self.imgArr.count)")
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ServiceItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row].image
            
        }
       
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        pageControl.currentPage = currentIndex
        
    }
    
    
}
