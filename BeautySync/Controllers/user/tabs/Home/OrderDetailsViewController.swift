//
//  OrderDetailsViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/10/24.
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

class OrderDetailsViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var location1: UILabel!
    
    @IBOutlet weak var customLocationYes: MDCButton!
    @IBOutlet weak var customLocationNo: MDCButton!
    
    @IBOutlet weak var customLocationButton: UIButton!
    @IBOutlet weak var location2: UILabel!
    //61
    //103
    @IBOutlet weak var notesToBeauticianConstraint: NSLayoutConstraint!
    @IBOutlet weak var notesToBeautician: UITextField!
    @IBOutlet weak var total: UILabel!
    
    //Location
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationStreetAddress: UITextField!
    @IBOutlet weak var locationStreetAddress2: UITextField!
    @IBOutlet weak var locationCity: UITextField!
    @IBOutlet weak var locationState: UITextField!
    @IBOutlet weak var locationZipCode: UITextField!
    
    var customLocation = "no"
    var item : ServiceItems?
    
    var streetAddress = ""
    var city = ""
    var state = ""
    var zipCode = ""
    
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"

        if item != nil {
            self.itemTitle.text = item!.itemTitle
            self.itemDescription.text = "\(item!.itemDescription)"
            self.total.text = "$\(item!.itemPrice)"
        }
        var date1 = dateFormatter.string(from: datePicker.date)
        print("datePicker2 \(date1)")
        let year = "\(datePicker.date)".prefix(4)
        let month = "\(datePicker.date)".prefix(7).suffix(2)
        let day = "\(datePicker.date)".prefix(10).suffix(2)
        var hour = "\(Int("\(datePicker.date)".prefix(13).suffix(2))!)"
        let min = "\(datePicker.date)".prefix(16).suffix(2)
        let sec = "\(datePicker.date)".prefix(19).suffix(2)
        
        if Int(hour)! < 10 {
            hour = "0\(hour)"
        } else if Int(hour)! > 12 {
            hour = "\(Int(hour)! - 12)"
            if Int(hour)! < 10 {
                hour = "0\(hour)"
            }
        }
        print("year \(year)")
        print("month \(month)")
        print("day \(day)")
        print("hour \(hour)")
        print("min \(min)")
        print("sec \(sec)")
        
        loadBeauticianLocation()
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var date1 = dateFormatter.string(from: datePicker.date)
        var hour = "\(Int("\(date1)".prefix(13).suffix(2))!)"
        let min = "\(date1)".prefix(16).suffix(2)
        
        if Int(hour)! < 10 {
            hour = "0\(hour)"
        } else if Int(hour)! > 12 {
            hour = "\(Int(hour)! - 12)"
            if Int(hour)! < 10 {
                hour = "0\(hour)"
            }
        }
        
        
        var a = "\(hour):\(min)"
        var b = date1.suffix(2)
        var c = "\(a) \(b)"
        
        let data : [String: Any] = ["itemType" :  item!.itemType, "itemTitle" : self.itemTitle.text!, "itemDescription" : self.itemDescription.text!, "itemPrice" : item!.itemPrice, "imageCount" : item!.imageCount, "beauticianUsername" : item!.beauticianUsername, "beauticianPassion" : item!.beauticianPassion, "beauticianCity" : city, "beauticianState": state, "beauticianImageId" : item!.beauticianImageId, "liked" : item!.liked, "itemOrders" : item!.itemOrders, "itemRating" : item!.itemRating, "hashtags" : item!.hashtags, "eventDay" : "\(date1)".prefix(10), "eventTime": c, "streetAddress" : streetAddress, "zipCode" : zipCode, "notesToBeautician" : notesToBeautician.text!]
        
        self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Cart").document().setData(data) { error in
            if error == nil {
                self.showToastCompletion(message: "Event Added.", font: .systemFont(ofSize: 12))
            }
        }
    }
    
    
    private func loadBeauticianLocation() {
        db.collection("Beautician").document(item!.beauticianImageId).collection("BusinessInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let streetAddress = data["streetAddress"] as? String, let city = data["city"] as? String, let state = data["state"] as? String, let zipCode = data["zipCode"] as? String {
                            
                            self.streetAddress = streetAddress
                            self.city = city
                            self.state = state
                            self.zipCode = zipCode
                            
                            self.location1.text = "\(streetAddress) \(city), \(state) \(zipCode)"
                        }
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
}
