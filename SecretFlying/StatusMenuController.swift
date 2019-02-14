//
//  StatusMenuController.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()

    init(storyboard: NSStoryboard) {
        super.init()

        let icon = NSImage(named: "StatusBarIcon")
        icon?.isTemplate = true

        let vc = storyboard.instantiateController(withIdentifier: "WhoaLookAtThoseDeals")
        popover.contentViewController = vc as? NSViewController
        popover.behavior = .transient
        popover.animates = false

        if let button = statusItem.button {
            button.image = icon

            button.target = self
            button.action = #selector(handleClick(sender:))
        }
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(
                relativeTo: button.bounds,
                of: button,
                preferredEdge: .minY
            )
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }

    func hidePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }

    @objc func handleClick(sender: AnyObject?) {
        if popover.isShown {
            hidePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
}
