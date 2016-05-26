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
        self.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }

        // set up module requires.
        // very hacky, but fine for simple things :)
        let require: @convention(block) String -> AnyObject = { [weak self] input in
            let fileURL = self!.URLForJSResource(input);
            let requireContext = RequireAwareJSContext.init(virtualMachine: self!.virtualMachine)

            if (fileURL == nil) {
                return requireContext.evaluateScript("throw new Exception('can\'t find \(input)');")
            }

            let resources = NSBundle.mainBundle().resourceURL
            let filePath = fileURL?.URLByDeletingLastPathComponent
            let fileContext = filePath?.path?.stringByReplacingOccurrencesOfString((resources?.path)!, withString: "")

            // for future require()s
            if (fileContext != "") {
                requireContext.setObject(fileContext, forKeyedSubscript: "__dirname")
            }

            requireContext.setObject(unsafeBitCast(NSDictionary(), AnyObject.self), forKeyedSubscript: "exports")
            requireContext.setObject(unsafeBitCast(NSDictionary(dictionary: ["exports": NSDictionary()]), AnyObject.self), forKeyedSubscript: "module")

            do {
                let contentsString = try String.init(contentsOfURL: fileURL!)
                requireContext.evaluateScript(contentsString)
            } catch {
                print(error)
            }

            return requireContext.objectForKeyedSubscript("module").objectForKeyedSubscript("exports")
        }

        self.setObject(unsafeBitCast(require, AnyObject.self), forKeyedSubscript: "require")
    }



    // js loading helpers
    func URLForJSResource(resource: String) -> NSURL? {
        let fileURL = findFileNamed(resource)

        if (fileURL == nil) {
            print("error require(), couldn't find", resource)
        }

        return fileURL
    }

    func findFileNamed(name: String) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        var isDirectory: ObjCBool = ObjCBool(false)

        let candidate = NSBundle.mainBundle().URLForResource(
            name,
            withExtension: "js"
        )

        if candidate != nil && fileManager.fileExistsAtPath(candidate!.path!, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                return candidate
            }
        }

        return nil
    }
}