//
//  JSONHelper.swift
//  RssIt
//
//  Created by Robin Wiegand on 15.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Diese Klasse kuemmert sich um die Serialisierung von Objekten. In diesem Fall wird ein Array mit WebsiteItems in
//                  ein JSONArray umgewandelt und auch umgekehrt.
//
//  Ressourcen:     https://medium.com/swift-programming/4-json-in-swift-144bf5f88ce4

import Foundation

class JSONHelper {

    
//Wandelt einen JSON-String in AnyObject um
private func JSONParseArray(jsonString: String) -> [AnyObject] {
    if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
        if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [AnyObject] {
            return array
        }
    }
    return [AnyObject]()
}

//Wandelt AnyObject in einen JSON-String um
private func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    if NSJSONSerialization.isValidJSONObject(value) {
        if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
        }
    }
    return ""
}

//Nimmt den JSON-String entgegen und generiert daraus das WebsiteItem-Array
func CreateWebsiteItems(jsonString: String) -> [WebsiteItem] {
    var websiteItems: [WebsiteItem] = []
    
    for elem: AnyObject in JSONParseArray(jsonString) {

        let websiteURLTemp = elem["websiteurl"] as String
        let websiteNameTemp = elem["websitename"] as String
        let idTemp = elem["id"] as String

        var selectedWebsiteItem: WebsiteItem = WebsiteItem(websiteName: websiteNameTemp, websiteURL: websiteURLTemp, id: idTemp)
        
        websiteItems.append(selectedWebsiteItem)
    }
    
    return websiteItems
}

//Nimmt ein Array mit WebsiteItems entgegen und generiert daraus einen String, der dann zurueckgegeben wird
  func CreateJSONString(websiteItems: [WebsiteItem]) -> String {
    var jsonString: String = String()
    var jsonObjects: [AnyObject] = [AnyObject]()
    
    for elem: WebsiteItem in websiteItems {
        
        let tempObject: AnyObject = ["websitename": elem.websiteName, "websiteurl": elem.websiteURL, "id": elem.id]
        jsonObjects.append(tempObject)
        
    }
    
    jsonString = JSONStringify(jsonObjects)
    
    return jsonString
}
    
}