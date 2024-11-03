//
//  OwnersViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class OwnersViewController: UIViewController {

    @IBOutlet weak var owner1: UILabel!
    @IBOutlet weak var owner2: UILabel!
    @IBOutlet weak var owner3: UILabel!
    @IBOutlet weak var owner4: UILabel!
    
    var newOrEdit = "new"
    var businessBankingInfo : BusinessBankingInfo?
    var newPersonOrEditedPerson = "new"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func owner1ButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = newOrEdit
            vc.typeOfPerson = "owner1"
            if owner1.text == "Add Owner" {
                vc.newPersonOrEditPerson = "new" } else { vc.newPersonOrEditPerson = "edit" }
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func owner2ButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = newOrEdit
            vc.typeOfPerson = "owner2"
            if owner2.text == "Add Owner" {
                vc.newPersonOrEditPerson = "new" } else { vc.newPersonOrEditPerson = "edit" }
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func owner3ButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = newOrEdit
            vc.typeOfPerson = "owner3"
            if owner3.text == "Add Owner" {
                vc.newPersonOrEditPerson = "new" } else { vc.newPersonOrEditPerson = "edit" }
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func owner4ButtonPressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            vc.newOrEdit = newOrEdit
            vc.typeOfPerson = "owner4"
            if owner4.text == "Add Owner" {
                vc.newPersonOrEditPerson = "new" } else { vc.newPersonOrEditPerson = "edit" }
            vc.businessBankingInfo = self.businessBankingInfo
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
}
