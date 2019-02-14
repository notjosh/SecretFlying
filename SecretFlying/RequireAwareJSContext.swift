//
//  RequireAwareJSContext.swift
//  AppliedJavaScriptDemo
//
//  Created by joshua may on 1/12/2015.
//  Copyright © 2015 notjosh, inc. All rights reserved.
//

import JavaScriptCore

class RequireAwareJSContext : JSContext {
    override init!() {
        super.init()
        common()
    }

    override init!(virtualMachine: JSVirtualMachine!) {
        super.init(virtualMachine: virtualMachine)
        common()
    }

    func common() {
        self.exceptionHandler = { (context, exception) -> Void in
            print("JS Error: \(String(describing: exception))")
        }

        // set up module requires.
        // very hacky, but fine for simple things :)
        let require: @convention(block) (String) -> AnyObject = { [weak self] input in
            guard
                let requireContext = RequireAwareJSContext.init(virtualMachine: self!.virtualMachine)
                else {
                    fatalError("requireContext :(")
            }

            guard
                let fileURL = self!.URLForJSResource(resource: input)
                else {
                    return requireContext.evaluateScript("throw new Exception('can\'t find \(input)');")
            }

            let resources = Bundle.main.resourceURL
            let filePath = fileURL.deletingLastPathComponent()
            let fileContext = filePath.path.replacingOccurrences(of: (resources?.path)!, with: "")

            // for future require()s
            if (fileContext != "") {
                requireContext.setObject(fileContext, forKeyedSubscript: "__dirname" as NSCopying & NSObjectProtocol)
            }

            requireContext.setObject(unsafeBitCast(NSDictionary(), to: AnyObject.self), forKeyedSubscript: "exports" as NSCopying & NSObjectProtocol)
            requireContext.setObject(unsafeBitCast(NSDictionary(dictionary: ["exports": NSDictionary()]), to: AnyObject.self), forKeyedSubscript: "module" as NSCopying & NSObjectProtocol)

            do {
                let contentsString = try String.init(contentsOf: fileURL)
                requireContext.evaluateScript(contentsString)
            } catch {
                print(error)
            }

            return requireContext.objectForKeyedSubscript("module").objectForKeyedSubscript("exports")
        }

        self.setObject(unsafeBitCast(require, to: AnyObject.self), forKeyedSubscript: "require" as NSCopying & NSObjectProtocol)
    }



    // js loading helpers
    func URLForJSResource(resource: String) -> URL? {
        let fileURL = findFileNamed(name: resource)

        if (fileURL == nil) {
            print("error require(), couldn't find", resource)
        }

        return fileURL
    }

    func findFileNamed(name: String) -> URL? {
        guard let candidate = Bundle.main.url(forResource: name, withExtension: "js") else {
            return nil
        }

        let fileManager = FileManager.default
        var isDirectory = ObjCBool(false)

        if fileManager.fileExists(atPath: candidate.path, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                return candidate
            }
        }

        return nil
    }
}
