//
//  File.swift
//  RssIt
//
//  Created by Robin Wiegand on 14.11.14.
//  Copyright (c) 2014 Robin Wiegand. All rights reserved.
//
//  Beschreibung:   Diese Klasse organisiert das Datei-Handling. Die angelegten Websites sollen im JSON-Format auf dem Geraet gespeichert werden.
//                  Dafuer wird ein json-File erzeugt, welches dann mit dem entsprechenden Inhalt gefuellt wird. Zum optimalen Zugriff
//                  steht eine read und eine write Methode zur Verfuegung.
//
//  Ressourcen:     https://gist.github.com/frozzare/d4a9bbeb39e5425e7c26


import Foundation

class File {
    
    let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
    
    var pathTF: String = String()

    init() {
        //Den Documents-Pfad finden
        if ((dirs) != nil) {
            let dir = dirs![0];
            pathTF = dir.stringByAppendingPathComponent("tempFile.json");
         }
    }

    //Existiert die Datei schon?
    func exists (path: String) -> Bool {
        return NSFileManager().fileExistsAtPath(path)
    }
    
    //Lesen
    func read (encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if exists(self.pathTF) {
            return String(contentsOfFile: self.pathTF, encoding: encoding, error: nil)!
        }
        
        return nil
    }
    
    //Schreiben
    func write (content: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        return content.writeToFile(self.pathTF, atomically: true, encoding: encoding, error: nil)
    }
}
