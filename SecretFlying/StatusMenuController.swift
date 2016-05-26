//
//  StatusMenuController.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let popover = NSPopover()

    init(storyboard: NSStoryboard) {
        super.init()

        let icon = NSImage(named: "StatusBarIcon")
        icon?.template = true

        let vc = storyboard.instantiateControllerWithIdentifier("WhoaLookAtThoseDeals")
        popover.contentViewController = vc as? NSViewController
        popover.behavior = .Transient
        popover.animates = false

        if let button = statusItem.button {
            button.image = icon

            button.target = self
            button.action = #selector(handleClick(_:))
        }
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(
                button.bounds,
                ofView: button,
                preferredEdge: .MinY
            )
            NSApplication.sharedApplication().activateIgnoringOtherApps(true)
        }
    }

    func hidePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }

    func handleClick(sender: AnyObject?) {
        if popover.shown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}
