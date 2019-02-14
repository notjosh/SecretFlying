//
//  main.swift
//  SecretFlyingLoginHelper
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

autoreleasepool { () -> () in
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
