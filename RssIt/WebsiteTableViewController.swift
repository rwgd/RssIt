//
//  WebsiteTableViewController.swift
//  RssIt
//
//  Created by Robin Wiegand on 24.10.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Controller zur Anzeige der angelegten Websites. Hier werden die Daten auf dem Geraet abgespeichert und mit dem Server
//                  synchronisiert. Wenn die App das erste mal gestartet wird, werden Beispieleintraege generiert.

import UIKit

class WebsiteTableViewController: UITableViewController {
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        println("Unwinding")
    }
    
    var websiteRefreshControl:UIRefreshControl!
    
    var websiteItems: [WebsiteItem] = []
    var selectedWebsiteItem: WebsiteItem = WebsiteItem(websiteName: "", websiteURL: "", id: "")
    
    
    let fileObj = File()
    let helper = JSONHelper()
    let restHelper = RESTHelper()
    
    func saveData(){
        var json: String = String()
        json = helper.CreateJSONString(websiteItems)
        println(json)
        let write : Bool = fileObj.write(json)
    }
    
    func readData(){
        if var read = fileObj.read(){
            println("Datei existiert")
            websiteItems = helper.CreateWebsiteItems(read)
        } else {
            println("Keine Datei vorhanden")
            //Also Anfangsdaten anlegen
            websiteItems = [
                WebsiteItem(websiteName: "Caschys Blog", websiteURL: "http://feeds2.feedburner.com/stadt-bremerhaven/dqXM", id: "555"),
                WebsiteItem(websiteName: "Kraftfuttermischwerk", websiteURL: "http://www.kraftfuttermischwerk.de/blogg/feed/", id: "432"),
                WebsiteItem(websiteName: "Nerdcore", websiteURL: "http://feeds.feedburner.com/NerdcoreRSS2", id: "3")
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.websiteRefreshControl = UIRefreshControl()
        self.websiteRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.websiteRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        readData()
    }
    
    override func numberOfSectionsInTableView(tableView: (UITableView!)) -> Int {
        return 1  
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websiteItems.count 
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tempCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
        let websiteItem = websiteItems[indexPath.row]
        
        // Downcast from UILabel? to UILabel
        let cell = tempCell.textLabel as UILabel!
        cell.text = websiteItem.websiteName
        
        println("row = %d",indexPath.row)
        //pull to refresh

        tableView.addSubview(websiteRefreshControl)
        
        return tempCell
    }
    
    //bei swipe element löschen
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //Website auch auf dem Server löschen
            restHelper.deleteWebsite(websiteItems[indexPath.row].id)
            
            websiteItems.removeAtIndex(indexPath.row)

            //Daten aktualisiert auf dem Gerät abspeichern
            saveData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    func refresh(sender:AnyObject)
    {
        //Die neusten Daten vom Server holen
        restHelper.getWebsites {
            websiteItems in
            self.websiteItems = websiteItems
            self.tableView.reloadData()
            self.websiteRefreshControl.endRefreshing()
        }

    }
    
    @IBAction func unwindAndAddToList(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as AddWebsiteViewController
        let websiteItem:WebsiteItem = source.websiteItem
        
        if websiteItem.websiteName != "" {
            self.websiteItems.append(websiteItem)
            self.tableView.reloadData()
            //Websites mit dem Server syncen
            restHelper.setWebsites(self.websiteItems)
            //Websites serialisiert auf dem Gerät speichern
            saveData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "articlesSegue"{
            let selectedIndex = self.tableView.indexPathForCell(sender as UITableViewCell)
            self.selectedWebsiteItem = self.websiteItems[selectedIndex!.row]
            
            var articleTableViewController = segue.destinationViewController as ArticleTableViewController
            articleTableViewController.selectedWebsiteItem = self.selectedWebsiteItem
            
            println("selected = %d",selectedIndex!.row)
        }

    }

}
