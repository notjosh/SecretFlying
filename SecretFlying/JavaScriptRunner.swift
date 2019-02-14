//
//  JavaScriptRunner.swift
//  SecretFlying
//
//  Created by joshua may on 1/12/2015.
//  Copyright © 2015 notjosh, inc. All rights reserved.
//

import JavaScriptCore

class JavaScriptRunner {
    let context: JSContext

    init() {
        context = RequireAwareJSContext()
    }

    func run(HTML: String) -> [ExtremeSuperAmazingDeal] {
        context.evaluateScript("var jsonify = require('jsonify')")

        let jsonifyFunction = context.evaluateScript("jsonify")
        let jsonifyFunctionResponse = jsonifyFunction?.call(withArguments: [HTML])

        let jsonDeals = jsonifyFunctionResponse?.toArray() as? [[String: AnyObject]]

        return jsonDeals?.compactMap { (jsonDeal: [String : AnyObject]) -> ExtremeSuperAmazingDeal? in
            if jsonDeal["id"] == nil {
                return nil
            }

            if jsonDeal["date"] == nil {
                return nil
            }

            if jsonDeal["title"] == nil {
                return nil
            }

            if jsonDeal["summary"] == nil {
                return nil
            }

            if jsonDeal["thumbnail_url"] == nil {
                return nil
            }

            if jsonDeal["url"] == nil {
                return nil
            }

            return ExtremeSuperAmazingDeal(
                id: jsonDeal["id"] as! String,
                date: jsonDeal["date"] as! String,
                title: jsonDeal["title"] as! String,
                summary: jsonDeal["summary"] as! String,
                thumbnailURL: URL(string: (jsonDeal["thumbnail_url"] as! String).replacingOccurrences(of: "http://", with: "https://"))!,
                URL: URL(string: jsonDeal["url"] as! String)!
            )
        } ?? []
    }
}
