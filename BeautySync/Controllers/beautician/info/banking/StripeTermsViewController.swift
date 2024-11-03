//
//  StripesTermsViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 10/31/24.
//

import UIKit
import WebKit

class StripeTermsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURLString = "https://stripe.com/legal/connect-account"
        let url = URL(string: myURLString)
        let request = URLRequest(url: url!)
        
        let webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
