//
//  AppDelegate.swift
//  SecretFlying
//
//  Created by joshua may on 25/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
    let statusMenuController: StatusMenuController

    override init() {
        statusMenuController = StatusMenuController.init(storyboard: storyboard)
        
        super.init()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {

    }

    func applicationWillTerminate(aNotification: NSNotification) {

    }


}