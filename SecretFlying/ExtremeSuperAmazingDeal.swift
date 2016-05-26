//
//  ExtremeSuperAmazingDeal.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Foundation

class ExtremeSuperAmazingDeal : CustomStringConvertible {
    let id: String
    let date: String
    let title: String
    let summary: String
    let thumbnailURL: NSURL
    let URL: NSURL

    var expired: Bool {
        get {
            return self.title.containsString("**EXPIRED**")
        }
    }

    var description: String {
        var description: String = ""
        description = "***** \(self.dynamicType) - <\(unsafeAddressOf((self as AnyObject)))>***** \n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }

    init(id: String, date: String, title: String, summary: String, thumbnailURL: NSURL, URL: NSURL) {
        self.id = id
        self.date = date
        self.title = title
        self.summary = summary
        self.thumbnailURL = thumbnailURL
        self.URL = URL
    }
}
