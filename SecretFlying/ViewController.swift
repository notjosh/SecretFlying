//
//  ViewController.swift
//  SecretFlying
//
//  Created by joshua may on 25/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

import ITProgressIndicator

class ViewController: NSViewController {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var settingsMenu: NSMenu!
    @IBOutlet var refreshButton: NSButton!
    @IBOutlet var progressIndicator: ITProgressIndicator!

    let provider = DealsProvider.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    @IBAction func handleClick(sender: AnyObject) {
        let row = tableView.selectedRow

        guard
            row != -1 else {
            return
        }

        let deal = provider.deals[row]

        NSWorkspace.shared.open(deal.URL as URL)
        tableView.deselectRow(row)
    }

    @IBAction func handleRefreshButton(sender: AnyObject?) {
        refresh()
    }

    @IBAction func handleSettingsButton(sender: AnyObject?) {
        guard let view = sender as? NSView else {
            return
        }

        settingsMenu.popUp(
            positioning: nil,
            at: NSPoint(
                x: NSMaxX(view.bounds),
                y: NSMidY(view.bounds)
            ),
            in: view
        )
    }

    func refresh() {
        refreshButton.isEnabled = false
        progressIndicator.isHidden = false
        provider.refresh {
            DispatchQueue.main.async { [weak self] in
                self?.refreshButton.isEnabled = true
                self?.progressIndicator.isHidden = true
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return provider.deals.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 215
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DealCellView"), owner: self) as! DealCellView
        let deal = provider.deals[row]

        cell.itemName.stringValue = deal.title
        cell.itemDescription.stringValue = deal.summary

        cell.itemImage.af_setImageWithURL(URL: deal.thumbnailURL)
        cell.itemImage.wantsLayer = true
        cell.itemImage.layerUsesCoreImageFilters = true

        if (deal.isExpired) {
            let filterColorControls = CIFilter.init(name: "CIColorControls")
            filterColorControls?.setDefaults()
            filterColorControls?.setValue(-0.5, forKey: kCIInputBrightnessKey)
            filterColorControls?.setValue(0.0, forKey: kCIInputSaturationKey)

            let filterSepia = CIFilter.init(name: "CISepiaTone")
            filterSepia?.setDefaults()

            cell.itemImage.layer?.filters = [filterColorControls!, filterSepia!]
        } else {
            cell.itemImage.layer?.filters = []
        }

        return cell
    }
}
