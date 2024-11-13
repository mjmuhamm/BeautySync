//
//  ItemDetailViewController.swift
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


class ItemDetailViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var expectationsMet1: UIImageView!
    @IBOutlet weak var expectationsMet2: UIImageView!
    @IBOutlet weak var expectationsMet3: UIImageView!
    @IBOutlet weak var expectationsMet4: UIImageView!
    @IBOutlet weak var expectationsMet5: UIImageView!
    
    @IBOutlet weak var quality1: UIImageView!
    @IBOutlet weak var quality2: UIImageView!
    @IBOutlet weak var quality3: UIImageView!
    @IBOutlet weak var quality4: UIImageView!
    @IBOutlet weak var quality5: UIImageView!
    
    @IBOutlet weak var beauticianRating1: UIImageView!
    @IBOutlet weak var beauticianRating2: UIImageView!
    @IBOutlet weak var beauticianRating3: UIImageView!
    @IBOutlet weak var beauticianRating4: UIImageView!
    @IBOutlet weak var beauticianRating5: UIImageView!
    
    @IBOutlet weak var itemPrice: UILabel!
    var item: ServiceItems?
    
    var imgArr: [UIImage] = []
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item != nil {
            if item!.itemImage != nil {
                imgArr.append(item!.itemImage!)
            }
        }
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        
        self.pageControl.numberOfPages = self.imgArr.count
        self.pageControl.currentPage = 0
        photoCollectionView.reloadData()
        loadInfo()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func orderButtonPressed(_ sender: Any) {
        
    }
    
    private func loadInfo() {
        loadImages()
        self.itemTitle.text = item!.itemTitle
        self.itemDescription.text = item!.itemDescription
        self.itemPrice.text = "$\(item!.itemPrice)"
        self.userName.text = "\(item!.beauticianUsername)"
    }
    
    private func loadImages() {
        for i in 1..<item!.imageCount {
            storage.reference().child("\(item!.itemType)/\(item!.beauticianImageId)/\(item!.documentId)/\(item!.documentId)\(i).png").downloadURL { url, error in
                if error == nil {
                    if url != nil {
                        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                            // Error handling...
                            guard let imageData = data else { return }
                            
                            DispatchQueue.main.async {
                                self.imgArr.append(UIImage(data: imageData)!)
                                self.pageControl.numberOfPages = self.imgArr.count
                                self.photoCollectionView.reloadData()
                            }
                        }.resume()
                    }
                    
                }
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
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = photoCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / photoCollectionView.frame.size.width)
        pageControl.currentPage = currentIndex
        
    }
    
}
