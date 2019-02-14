//
//  ExtremeSuperAmazingDeal.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Foundation

struct ExtremeSuperAmazingDeal : CustomStringConvertible {
    let id: String
    let date: String
    let title: String
    let summary: String
    let thumbnailURL: URL
    let URL: URL

    var isExpired: Bool {
        return title.contains("**EXPIRED**")
    }

    var description: String {
        var description: String = ""
        description = "***** \(type(of: self)) ***** \n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }

    init(id: String, date: String, title: String, summary: String, thumbnailURL: URL, URL: URL) {
        self.id = id
        self.date = date
        self.title = title
        self.summary = summary
        self.thumbnailURL = thumbnailURL
        self.URL = URL
    }
}
