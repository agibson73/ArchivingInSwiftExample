//
//  AppDelegate.swift
//  ArchivingInSwiftExample
//
//  Created by Steven Gibson on 1/14/15.
//  Copyright (c) 2015 OakmontTech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
      
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        
        //save to our archiving class using our singleton
       let saved = DiaryEntryStore.sharedInstance.save()
        if saved == true
        {
            println("It saved")
        }
        else
        {
            println("No dice")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
       
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

