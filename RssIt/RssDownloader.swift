//
//  RssDownloader.swift
//  RssIt
//
//  Created by Robin Wiegand on 04.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Diese Klasse parst den RSS-Feed und erzeugt ein Array aus ArticleItem. Damit die Internetkommunikation asynchron geschieht,
//                  erbt RssDownloader.swift von NSOperation.

import UIKit

class RssDownloader: NSOperation, NSXMLParserDelegate {
    
    var articleItems: [ArticleItem] = []
    
    var parser: NSXMLParser = NSXMLParser()
    
    var articleTitle: String = String()
    var articleDes: String = String()
    var articleLink: String = String()
    var eName: String = String()
    var websiteURL: String = String()
    
    init(websiteURL: String) {
        self.websiteURL = websiteURL
    }
    
    override func main() -> (){
        println("hello from background")
        let url:NSURL = NSURL(string: websiteURL)!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
        println("bye from background")
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if elementName == "item" || elementName == "entry" {
            articleTitle = String()
            articleLink = String()
        }
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if eName == "title" {
                articleTitle += data
            } else if eName == "link" {
                articleLink += data
            }
        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!){
        if elementName == "item" || elementName == "entry"{
            let articleItem1: ArticleItem = ArticleItem(articleTitle: articleTitle, articleDate: "", articleDes: "", articleLink: articleLink)
            
            articleItems.append(articleItem1)
        }
    }

}
