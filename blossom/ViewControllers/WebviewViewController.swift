//
//  WebviewViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 3. 7..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import Foundation
import UIKit

class WebviewViewController: UIViewController {
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var titleLable: UILabel!
    
    var url: URL = URL(string:"http://www.shobit.co.kr")!
    var webviewTitle: String = ""
    
    @IBAction func cancleTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        titleLable.text = webviewTitle
        webview.loadRequest(URLRequest(url: self.url as URL))
    }
    
}
