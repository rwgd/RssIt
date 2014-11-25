//
//  ArticleTableViewController.swift
//  RssIt
//
//  Created by Robin Wiegand on 01.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Controller zur Anzeige der einzelnen Artikel, nachdem diese geparsed wurden. Eingebautes Pull-To-Refresh um die Daten erneut
//                  zu laden. Das laden der Artikel geschieht asynchron mit Hilfe von NSOperation.

import UIKit


class ArticleTableViewController: UITableViewController {
    
    var articleRefreshControl:UIRefreshControl!
    var articleItems: [ArticleItem] = []
    var selectedWebsiteItem: WebsiteItem = WebsiteItem(websiteName: "", websiteURL: "", id: "")
    let queue = NSOperationQueue()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.selectedWebsiteItem.websiteName
        self.articleRefreshControl = UIRefreshControl()
        self.articleRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.articleRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        refreshArticleData()
        println("website = %d", self.selectedWebsiteItem.websiteName)
    }
    
    func refreshArticleData() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        let rssDownloader = RssDownloader(websiteURL: self.selectedWebsiteItem.websiteURL)
        //Hohe Priorität
        rssDownloader.queuePriority = .High
        //Handelt sich um eine Aktion, bei der der User direkt auf Ergebnis wartet
        rssDownloader.qualityOfService = .UserInitiated
        queue.addOperation(rssDownloader)
        rssDownloader.completionBlock = {() -> () in
            self.articleItems = rssDownloader.articleItems
            //auf main-thread tableview aktualisieren
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if((self.articleRefreshControl) != nil){
                    println("endrefreshing")
                    self.articleRefreshControl.endRefreshing()
                }
                self.tableView.reloadData()
                actInd.stopAnimating()
            })
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: (UITableView!)) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tempCell = tableView.dequeueReusableCellWithIdentifier("ArticleListPrototypeCell") as UITableViewCell
        let articleItem = articleItems[indexPath.row]

        let cell = tempCell.textLabel as UILabel!
        cell.text = articleItem.articleTitle
        
        //pull to refresh

        tableView.addSubview(articleRefreshControl)
        
        return tempCell
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        refreshArticleData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "websiteSegue"{
            let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
            var websiteViewController = segue.destinationViewController as WebsiteViewController
            websiteViewController.articleItem = self.articleItems[selectedIndex!.row]
        }
        
    }
  
    
    
}
