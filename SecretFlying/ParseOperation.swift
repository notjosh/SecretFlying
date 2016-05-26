//
//  ParseOperation.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

class ParseOperation: NSOperation {
    var deals: [ExtremeSuperAmazingDeal] = []

    let HTML: String

    init(HTML: String) {
        self.HTML = HTML
    }

    override func main() {
        let runner = JavaScriptRunner()
        deals = runner.run(HTML)
    }
}
