//
//  RefreshOperation.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

import Cocoa

import Alamofire

class RefreshOperation: NSOperation {
    let region: String
    var deals: [ExtremeSuperAmazingDeal] = []

    var _executing: Bool = false
    var _finished: Bool = false

    override var concurrent: Bool {
        get {
            return true
        }
    }

    override var executing: Bool {
        get {
            return _executing
        }
    }

    override var finished: Bool {
        get {
            return _finished
        }
    }

    init(_ region: String) {
        self.region = region

        super.init()
    }

    func stop() {
        willChangeValueForKey("isExecuting")
        _executing = false
        didChangeValueForKey("isExecuting")
    }

    func finish() {
        willChangeValueForKey("isFinished")
        _finished = true
        didChangeValueForKey("isFinished")
    }

    override func main() {
        willChangeValueForKey("isExecuting")
        _executing = true
        didChangeValueForKey("isExecuting")

//        let URLString = "http://localhost/~joshua/play/secret-flying/\(region).html"
        let URLString = "https://www.secretflying.com/\(region)/"
        let userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"

        let URLRequest = NSMutableURLRequest(URL: NSURL.init(string: URLString)!)
        URLRequest.HTTPMethod = "GET"
        URLRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        Alamofire.request(URLRequest)
            .responseString(encoding: NSUTF8StringEncoding) { [weak self] (response: Response<String, NSError>) in
                guard response.result.isSuccess else {
                    self?.stop()
                    self?.finish()
                    return;
                }
                self?.parse(response.result.value)
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
