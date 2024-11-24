//
//  SchedulingViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/16/24.
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

class SchedulingViewController: UIViewController {

    let db = Firestore.firestore()
    @IBOutlet weak var changeDateButton: MDCButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var item : Orders?
    var beauticianOrUser = ""
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
        
        changeDateButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        changeDateButton.layer.cornerRadius = 5
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDateButtonPressed(_ sender: Any) {
        var beauticianOrUser = "User"
        var imageId = item!.userImageId
       
        
        //Now
        var date1 = dateFormatter.string(from: Date().addingTimeInterval(3550))
        
        //event day
        var date2 = dateFormatter.string(from: datePicker.date)
        var hour = "\(Int("\(date2)".prefix(13).suffix(2))!)"
        let min = "\(date2)".prefix(16).suffix(2)
        
        if date1 == date2 { self.showToast(message: "Your changed date must be atleast 1 hour from now.", font: .systemFont(ofSize: 12))}
        else if date1 > date2 { self.showToast(message: "Your changed date must be atleast 1 hour from now.", font: .systemFont(ofSize: 12))}
        else if date1 < date2 {
            
            if Int(hour)! < 10 {
                hour = "0\(hour)"
            } else if Int(hour)! > 12 {
                hour = "\(Int(hour)! - 12)"
                if Int(hour)! < 10 {
                    hour = "0\(hour)"
                }
            }
            
            //event time
            let a = "\(hour):\(min)"
            let b = date2.suffix(2)
            let c = "\(a) \(b)"
            
            
            let data : [String: Any] = ["date" : dateFormatter.string(from: Date()), "message" : "The beautician has changed the service date to \(date2.prefix(10)) \(c).", "beauticianOrUser" : ""]
            
            let data1: [String: Any] = ["eventDay" : "\(date2.prefix(10))", "eventTime" : c, "notifications" : "yes"]
            
            let data2: [String: Any] = ["eventDay" : "\(date2.prefix(10))", "eventTime" : c]
            
            self.db.collection("User").document(item!.userImageId).collection("Orders").document(item!.documentId).updateData(data1)
            self.db.collection("Beautician").document(item!.beauticianImageId).collection("Orders").document(item!.documentId).updateData(data2)
            self.db.collection("Orders").document(item!.documentId).updateData(data1)
            
            self.db.collection("Orders").document(item!.documentId).collection("Messages").document().setData(data)
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController {
                vc.item = self.item
                vc.beauticianOrUser = self.beauticianOrUser
                self.present(vc, animated: true, completion: nil)
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
