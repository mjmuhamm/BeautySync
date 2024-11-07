//
//  MeViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/6/24.
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

class BeauticianMeViewController: UIViewController {
    
    
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var notificationBell: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var settings: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var passion: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var hairButton: MDCButton!
    @IBOutlet weak var makeupButton: MDCButton!
    @IBOutlet weak var lashesButton: MDCButton!
    @IBOutlet weak var contentButton: MDCButton!
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    var itemType = "Hair"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        serviceTableView.register(UINib(nibName: "PersonalChefTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalChefReusableCell")
        serviceTableView.register(UINib(nibName: "ChefItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefItemReusableCell")
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        loadInfo()
    }
    
    private func loadInfo() {
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("PersonalInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                        for doc in documents!.documents {
                            let data = doc.data()
                            if let username = data["username"] as? String {
                                self.userName.text = username
                            }
                        }
                }
            }
        }
        
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("BusinessInfo").getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let passion = data["passion"] as? String, let city = data["city"] as? String, let state = data["state"] as? String {
                            self.passion.text = passion
                            self.location.text = "Location: \(city), \(state)"
                        }
                    }
                }
            }
        }
        
        let storageRef = storage.reference()
        storageRef.child("beauticians/\(Auth.auth().currentUser!.email!)/profilePic/\(Auth.auth().currentUser!.uid).png").downloadURL { url, error in
            if error == nil {
                if url != nil {
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        // Error handling...
                        guard let imageData = data else { return }
                        
                        print("happening itemdata")
                        DispatchQueue.main.async {
                            self.userImage.image = UIImage(data: imageData)!
                        }
                    }.resume()
                }
            }
        }
    }
    
    
    @IBAction func hairButtonPressed(_ sender: Any) {
        itemType = "Hair"
        hairButton.setTitleColor(UIColor.white, for: .normal)
        hairButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        makeupButton.backgroundColor = UIColor.white
        makeupButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        lashesButton.backgroundColor = UIColor.white
        lashesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func makeupButtonPressed(_ sender: Any) {
        itemType = "Makeup"
        hairButton.backgroundColor = UIColor.white
        hairButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        makeupButton.setTitleColor(UIColor.white, for: .normal)
        makeupButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        lashesButton.backgroundColor = UIColor.white
        lashesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func lashesButtonPressed(_ sender: Any) {
        itemType = "Lashes"
        hairButton.backgroundColor = UIColor.white
        hairButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        makeupButton.backgroundColor = UIColor.white
        makeupButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        lashesButton.setTitleColor(UIColor.white, for: .normal)
        lashesButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        contentButton.backgroundColor = UIColor.white
        contentButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func contentButtonPressed(_ sender: Any) {
        itemType = "Content"
        hairButton.backgroundColor = UIColor.white
        hairButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        makeupButton.backgroundColor = UIColor.white
        makeupButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        lashesButton.backgroundColor = UIColor.white
        lashesButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        contentButton.setTitleColor(UIColor.white, for: .normal)
        contentButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var item = ""
        if itemType == "Hair" { item = "Hair Item" } else if itemType == "Makeup" { item = "Makeup Item" } else if itemType == "Lashes" { item = "Lash Item" } else { item = "Content Item" }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceItem") as? ServiceItemsViewController {
            vc.itemType = item
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    

}

extension BeauticianMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "", for: indexPath) 
        
        return cell
    }
}
