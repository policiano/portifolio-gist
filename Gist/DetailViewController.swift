//
//  DetailViewController.swift
//  Gist
//
//  Created by Willian Fagner De Souza Policiano on 26/07/20.
//  Copyright © 2020 Willian. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        loadHTMLStringImage()
    }

    func loadHTMLStringImage() -> Void {
        let htmlString = "<script src=\"https://gist.github.com/281fbc5a4a15bc6c5733e2721f3e932f.js\"></script>"
        webView.scrollView.zoomScale = 2
        webView.loadHTMLString(htmlString, baseURL: nil)
    }


    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

