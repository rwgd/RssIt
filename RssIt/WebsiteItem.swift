//
//  WebsiteItem.swift
//  RssIt
//
//  Created by Robin Wiegand on 01.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Model fuer eine Internetseite.

import UIKit

class WebsiteItem: NSObject {
    
    let websiteName: String
    let websiteURL: String
    let id: String
    
    init(websiteName: String, websiteURL: String, id: String) {
        self.websiteName = websiteName
        self.websiteURL = websiteURL
        self.id = id
    }
    

}


