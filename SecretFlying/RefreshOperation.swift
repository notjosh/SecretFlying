//
//  RefreshOperation.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

import Alamofire

class RefreshOperation: Operation {
    let region: String
    var deals: [ExtremeSuperAmazingDeal] = []

    var _executing: Bool = false
    var _finished: Bool = false

    override var isConcurrent: Bool {
        get {
            return true
        }
    }

    override var isExecuting: Bool {
        get {
            return _executing
        }
    }

    override var isFinished: Bool {
        get {
            return _finished
        }
    }

    init(_ region: String) {
        self.region = region

        super.init()
    }

    func stop() {
        willChangeValue(forKey: "isExecuting")
        _executing = false
        didChangeValue(forKey: "isExecuting")
    }

    func finish() {
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinished")
    }

    override func main() {
        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")

//        let URLString = "http://localhost/~joshua/play/secret-flying/\(region).html"
        let URLString = "https://www.secretflying.com/\(region)/"
        let userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"

        var requ = URLRequest(url: URL(string: URLString)!)
        requ.httpMethod = "GET"
        requ.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        Alamofire
            .request(requ)
            .responseString(encoding: .utf8) { [weak self] response in
                guard response.result.isSuccess else {
                    self?.stop()
                    self?.finish()
                    return;
                }
                self?.parse(HTML: response.result.value)
        }
    }

    func parse(HTML: String?) {
        let op = ParseOperation(HTML: HTML!)
        op.completionBlock = { [weak self] in
            self?.deals = op.deals

            self?.stop()
            self?.finish()
        }
        op.start()
    }
}
