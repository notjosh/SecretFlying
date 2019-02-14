//
//  DealsProvider.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

class DealsProvider {
    var deals: [ExtremeSuperAmazingDeal] = []
    var queue = OperationQueue.init()
    var fetchRunning: Bool {
        get {
            return queue.operationCount != 0
        }
    }

    func refresh(completion: @escaping () -> Void) {
        guard !fetchRunning else {
            return
        }

        let op = RefreshOperation.init("euro-deals")
        op.completionBlock = { [weak self] in
            self?.deals = op.deals

            completion()
        }

        queue.addOperation(op)
    }
}
