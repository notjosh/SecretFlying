//
//  AppDelegate.swift
//  SecretFlyingLoginHelper
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var alreadyRunning = false
        var active = false
        let running = NSWorkspace.shared.runningApplications

        for app in running {
            if (app.bundleIdentifier == "com.notjosh.SecretFlying") {
                alreadyRunning = true
                active = app.isActive
                break
            }
        }

        if (!alreadyRunning || !active) {
            let path = Bundle.main.bundlePath
            var p = NSURL(string: path)?.pathComponents

            p?.removeLast(3)
            p?.append("MacOS")
            p?.append("SecretFlying")

            let newPath = NSURL.fileURL(withPathComponents: p!)!.path
            NSWorkspace.shared.launchApplication(newPath)
        }

        NSApp.terminate(nil)
    }
}

