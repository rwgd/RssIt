//
//  WebsiteViewController.swift
//  RssIt
//
//  Created by Robin Wiegand on 04.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Controller zur einfachen Webview, die die entsprechende Website zum RSS-Artikel anzeigen soll.

import UIKit

class WebsiteViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var websiteView: UIWebView!
    var articleItem: ArticleItem = ArticleItem(articleTitle: "", articleDate: "", articleDes: "", articleLink: "")
    var actInd : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.articleItem.articleTitle
        
        actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        websiteView.delegate = self
        var url = NSURL(string:articleItem.articleLink)
        var req = NSURLRequest(URL:url!)
        self.websiteView!.loadRequest(req)
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        actInd.stopAnimating()
    }
}
