//
//  RESTHelper.swift
//  RssIt
//
//  Created by Robin Wiegand on 22.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//  
//  Beschreibung:   Diese Klasse buendelt die Funktionen zum Aufruf der REST-Api.

import Foundation

class RESTHelper {
    
    let fileObj = File()
    let helper = JSONHelper()
    
    //Speichern eines WebsiteItem-Arrays auf dem Server
    func setWebsites(websiteItems: [WebsiteItem]){

        var json: String = String()
        json = helper.CreateJSONString(websiteItems)
        
        var bodyData = "json=" + json
        
        let url = NSURL(string: Constants.UrlSetWebsite)
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            var result = NSString(data: data, encoding: NSUTF8StringEncoding)
            if((result?.containsString("1")) != nil){
                println("erfolg")
            } else {
                println("fehler")
            }
        }
        
        task.resume()
        
    }
    
    //Ein WebsiteItem auf dem Server loeschen. Identifizierung anhand der ID
    func deleteWebsite(id: String){
        
        var bodyData = "id=" + id
        let url = NSURL(string: Constants.UrlDeleteWebsite)
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            var result = NSString(data: data, encoding: NSUTF8StringEncoding)
            if((result?.containsString("1")) != nil){
                println("erfolg")
            } else {
                println("fehler")
            }
        }
        
        task.resume()
        
    }
    
    //Gibt die aktuelle Liste der auf dem Server gespeicherten WebsiteItems zurueck.
    //http://stackoverflow.com/questions/25203556/returning-data-from-async-call-in-swift-function
    func getWebsites(completionHandler: (websiteItems: [WebsiteItem]) -> ()){

        var items: [WebsiteItem] = []

        let url = NSURL(string: Constants.UrlGetWebsite)
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            var rawString: String = NSString(data: data, encoding: NSUTF8StringEncoding)!
            let newString = rawString.stringByReplacingOccurrencesOfString("Optional(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            newString.substringToIndex(newString.endIndex.predecessor())
            
            items = self.helper.CreateWebsiteItems(newString)
            
            completionHandler(websiteItems: items)
        }
        
        task.resume()

    }
    
}
