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
    
    var itemType = ""
    var newOrEdit = "new"
    var serviceItemId = UUID().uuidString
    
    //Image
    var imgArr : [ServiceImage] = []
    var imgArrData: [Data] = []
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serviceItemLabel.text = "\(itemType)"
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
            
                self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(self.itemType).document(self.serviceItemId).delete()
                self.db.collection(self.itemType).document(self.serviceItemId).delete()
                let storageRef = self.storage.reference()
                Task {
                    try? await storageRef.child("beauticians/\(Auth.auth().currentUser!.uid)/\(self.itemType)/\(self.serviceItemId)").delete()
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
        
        if imgArr.count > 0 {
            if newOrEdit == "edit" {
                
                let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (handler) in
                    let storageRef = self.storage.reference()
                    let renewRef = self.storage.reference()
                    var path = self.imgArr[self.currentIndex].imgPath
                    
                    for i in 0..<self.imgArr.count {
                        Task {
                            try? await storageRef.child(self.imgArr[i].imgPath).delete()
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
                        renewRef.child("beauticians/\(Auth.auth().currentUser!.uid)/\(self.itemType)/\(self.serviceItemId)\(i).png").putData(self.imgArrData[i])
                    }
                    let data: [String: Any] = ["imageCount" : self.imgArr.count]
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(self.itemType).document(self.serviceItemId).updateData(data)
                    self.db.collection(self.itemType).document(self.serviceItemId).updateData(data)
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
                hashtagLabel.text = ", #\(hashtagText.text!)"
            }
            hashtags.append("#\(hashtagText.text!)")
            hashtagDeleteButton.isHidden = false
        }
    }
    
    @IBAction func hashtagDeleteButton(_ sender: Any) {
        hashtagDeleteButton.isHidden = true
        hashtags.removeAll()
        hashtagLabel.text = ""
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if itemTitle.text == "" {
            self.showToast(message: "Please enter an item title.", font: .systemFont(ofSize: 12))
        } else if imgArr.count == 0 {
            self.showToast(message: "Please select at least one image.", font: .systemFont(ofSize: 12))
        } else if itemDescription.text == "" {
            self.showToast(message: "Please enter an item description.", font: .systemFont(ofSize: 12))
        } else if itemPrice.text == "" {
            self.showToast(message: "Please enter an item price.", font: .systemFont(ofSize: 12))
        } else {
            let data : [String: Any] = ["itemTitle" : self.itemTitle.text!, "itemDescription" : self.itemDescription.text!, "itemPrice" : self.itemPrice.text!, "imageCount" : self.imgArr.count ]
            
            if newOrEdit == "new" {
                self.db.collection("Beautician").document("\(Auth.auth().currentUser!.uid)").collection(itemType).document(serviceItemId).setData(data)
                self.db.collection("\(itemType)").document("\(serviceItemId)").setData(data)
                let storageRef = storage.reference()
                for i in 0..<imgArr.count {
                    storageRef.child("\(self.itemType)/\(self.serviceItemId)\(i).png").putData(self.imgArrData[i]) { data, error in
                        if error == nil {
                            if i == self.imgArr.count-1 {
                                self.activityIndicator.isHidden = true
                                self.showToastCompletion(message: "Item Saved.", font: .systemFont(ofSize: 12))
                            }
                        }
                    }
                }
            } else {
                self.db.collection("Beautician").document("\(itemType)").collection(itemType).document(serviceItemId).updateData(data)
                self.db.collection("\(itemType)").document("\(serviceItemId)").updateData(data)
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
        
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imgArr.append(ServiceImage(image: image, imgPath: ""))
        self.imgArrData.append(image.pngData()!)
        self.cancelButton.isHidden = false
        self.pageControl.numberOfPages = self.imgArr.count
        var path = "chefs/\(Auth.auth().currentUser!.uid)/\(self.itemType)/\(self.serviceItemId)\(self.imgArr.count - 1).png"
        if newOrEdit == "edit" {
            let storageRef = self.storage.reference()
            storageRef.child(path).putData(image.pngData()!)
            
            let data: [String: Any] = ["imageCount" : self.imgArr.count]
            self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(self.itemType).document(self.serviceItemId).updateData(data)
            self.db.collection(self.itemType).document(self.serviceItemId).updateData(data)
            self.showToast(message: "Image Added.", font: .systemFont(ofSize: 12))
        }
        self.sliderCollectionView.reloadData()
//        imageView.image = image
        print("image arr count\(self.imgArr.count)")
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
