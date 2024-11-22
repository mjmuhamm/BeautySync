//
//  AddContentViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/20/24.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import AVFoundation
import PhotosUI
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class AddContentViewController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var saveButton: MDCButton!
    @IBOutlet weak var contentDescription: UITextField!
    
    @IBOutlet weak var playPauseImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player : AVPlayer!
    var layer : AVPlayerLayer!
    
    var videoId = UUID().uuidString
    var videoUrl : URL?
    
    var beauticianUsername = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        saveButton.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func addVideoButtonPressed(_ sender: Any) {
        if playPauseButton.isSelected == false && player != nil {
            player.pause()
            playPauseImage.isHidden = false
            playPauseButton.isSelected = true
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let video = UIImagePickerController()
            video.allowsEditing = true
            video.mediaTypes = [UTType.movie.identifier]
            video.delegate = self
            self.present(video, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        
        uploadVideoToStorage()
        
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if playPauseButton.isSelected {
            playPauseButton.isSelected = false
            playPauseImage.isHidden = true
            player.play()
        } else {
            playPauseButton.isSelected = true
            playPauseImage.isHidden = false
            player.pause()
        }
    }
    
    
    private func uploadVideoToStorage() {
        self.backButton.isHidden = true
            let storageRef = storage.reference().child("content/\(videoId).mp4")
            
        var description = ""
        if self.contentDescription.text != "" {
            description = self.contentDescription.text!
        }
        
        storageRef.putFile(from: videoUrl!, metadata: nil, completion: { storage, error in
            
            storageRef.downloadURL(completion: { url, error in
                
                if error == nil {
                    self.saveVideo(name: "\(self.beauticianUsername)", description: description, videoUrl: url!)
                }
            })
            
            
        })
        
    }
    
    private func saveVideo(name: String, description: String, videoUrl: URL) {
            
            var description = "no description"
            if self.contentDescription.text != nil || !self.contentDescription.text!.isEmpty {
                description = self.contentDescription.text!
            }
            let storageRef = storage.reference()
            let json: [String: Any] = ["name": "\(name)b", "description" : "\(description)", "videoUrl" : "\(videoUrl)"]
            
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
            var request = URLRequest(url: URL(string: "https://beautysync-videoserver.onrender.com/upload-video")!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let id = json["entry_id"] as? String,
                      let self = self else {
                    // Handle error
                    return
                }
                DispatchQueue.main.async {
                    print("this is id \(id)")
                    let data: [String: Any] = ["id" : id, "beauticianImageId" : Auth.auth().currentUser!.uid, "beauticianUsername" : self.beauticianUsername, "liked" : [], "views" : 0, "description" : description, "comments" : 0, "shared" : 0]
                    
                    self.db.collection("Content").document(id).setData(data)
                    self.db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Content").document(id).setData(data)
                    self.showToastCompletion(message: "Content Uploaded.", font: .systemFont(ofSize: 12))
                    self.activityIndicator.stopAnimating()
//                                    storageRef.child("chefs/malik@cheftesting.com/Content/\(self.videoId).png").delete { error in
//                                        if error == nil {
//                                        }
//                                    }
                }
                
            })
            task.resume()
            
        
        
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
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeauticianTab") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

extension AddContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let video = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL else {
            return
        }
        videoUrl = video.absoluteURL
        player = AVPlayer(url: URL(string: "\(video)")!)
        playPauseImage.isHidden = true
        playPauseButton.isSelected = false
        layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(layer)
        self.saveButton.isHidden = false
        
        player.play()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
