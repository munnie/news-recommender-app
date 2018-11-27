//
//  WebViewController.swift
//  NewsRecommender
//
//  Created by mun on 11/27/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var urlString: String?
    @IBOutlet var webView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = URL.init(string: urlString ?? ""){
            webView?.load(URLRequest.init(url: url))
        }
    }
    
    func setUpNavigationbar(){
        let next = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        navigationItem.rightBarButtonItems = [next]
    }
    
    @objc func doneTapped(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
