//
//  AddWebsiteViewController.swift
//  RssIt
//
//  Created by Robin Wiegand on 24.10.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Controller fuer die Website-Hinzufuegen-Seite. Hier kann ein Name und die entsprechende URL einer neuen Seite eingetragen
//                  werden. Beim Eintragen wird automatisch eine zufaellige ID generiert.

import UIKit

class AddWebsiteViewController: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textFieldURL: UITextField!
    
    var websiteItem: WebsiteItem = WebsiteItem(websiteName: "", websiteURL: "", id: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate=self    
        textFieldURL.delegate=self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {    
        if (countElements(self.textField.text) > 0) {
            //generiere zufaellige id zwischen 1000 und 10000
            let randomID = 1000 + Int(arc4random_uniform(UInt32(10000 - 1000 + 1)))
            self.websiteItem = WebsiteItem(websiteName: self.textField.text, websiteURL: self.textFieldURL.text, id: String(randomID))
            
        }
    }
    
    //wenn man ausserhalb des textfeldes klickt, soll sich die tastatur schliessen
    override func touchesBegan(touches: (NSSet!), withEvent event: (UIEvent!)) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool 
    {
        textField .resignFirstResponder()
        return true;
    }
}
