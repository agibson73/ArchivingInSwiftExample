//
//  DiaryEntry.swift
//  UISearchBar+TableView + Core Data
//  UISearchBar+TableView + Core Data
//
//  Created by Alex Gibson on 12/11/14.
//  Copyright (c) 2014 Alex Gibson . All rights reserved.
//


/* if i was really serious I would use this nice class but right now I am not going to do it.  This is just a misfit toy */
// if you want you can comment the entire thing out and the project will not hurt your computer

import UIKit

class DiaryEntry: NSObject,NSCoding {
    
    var title : NSString!
    var date : NSString!
    var entry : NSString!
    
    /*
    init(title : String, date : String,  entry : String) {
        
        self.title = title
        self.date = date
        self.entry = entry
        
    }
*/
    override init() {
        println("Init")
        super.init()
    }

    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        title = aDecoder.decodeObjectForKey("title") as String?
        date   = aDecoder.decodeObjectForKey("date") as String?
        entry = aDecoder.decodeObjectForKey("entry") as String?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(entry, forKey:"entry")
    }
    


}
