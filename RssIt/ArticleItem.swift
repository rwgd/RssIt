//
//  ArticleItem.swift
//  RssIt
//
//  Created by Robin Wiegand on 01.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Model fuer einen Artikel

import UIKit

class ArticleItem: NSObject {
    
    let articleTitle: String
    let articleDate: String
    let articleDes: String
    let articleLink: String
    
    init(articleTitle: String, articleDate: String, articleDes: String, articleLink: String) {
        self.articleTitle = articleTitle
        self.articleDate = articleDate
        self.articleDes = articleDes
        self.articleLink = articleLink
    }
    
}
