//
//  DiaryEntryStore.swift
//  ArchivingInSwiftExample
//
//  Created by Steven Gibson on 1/14/15.
//  Copyright (c) 2015 OakmontTech. All rights reserved.
//

import UIKit

class DiaryEntryStore: NSObject {
    
    // our array to hold all of our diary entries
    var diaryEntries = NSMutableArray()
    
    //nested struct for creating a singleton
    class var sharedInstance:DiaryEntryStore {
        struct Static {
            static let instance : DiaryEntryStore = DiaryEntryStore()
            //if they are saved we are reloading them
           

        }
        return Static.instance
    }
     // now we have a singleton, thank you Swift
    
    override init()
    {
        super.init()
        // here is where we unarchive our data if it exists
        self.unarchiveAndSet()
        
    }

    func unarchiveAndSet()
    {
        // use optional so that if no data exists it will just give us an empty array
        if let entries: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(pathForModel()!)
        {
            diaryEntries = entries as NSMutableArray
        }
    }
    
    
    // save function for calling in AppDelegate for did enter background
    func save() ->Bool {
        
        var path = self.pathForModel()
        return NSKeyedArchiver.archiveRootObject(diaryEntries, toFile: path!)
    }
    
    // path for saving which is just a string
    // i hardcoded this below but it is better to use static strings at the top so no mistakes are made
    func pathForModel() -> NSString? {
        if let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String] {
            if paths.count > 0 {
                var path = paths[0]
                var fm = NSFileManager()
                if !fm.fileExistsAtPath(path) {
                    var error :NSError?
                    fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error)
                }
                path = path.stringByAppendingPathComponent("diaryentries.dat")
                return path
            }
        }
        return nil
    }
    
    
  
    
    
    





}
