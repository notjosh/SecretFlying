//
//  AspectFillImageView.swift
//  SecretFlying
//
//  Created by joshua may on 26/05/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

// via https://github.com/onekiloparsec/KPCScaleToFillNSImageView/blob/master/KPCScaleToFillNSImageView.m

import Cocoa

class AspectFillImageView: NSImageView {

    override var imageScaling: NSImageScaling {
        get {
            return super.imageScaling
        }
        set {
            super.imageScaling = .ScaleAxesIndependently
        }
    }

    override var image: NSImage? {
        get {
            return super.image
        }
        set {
            guard newValue != nil else {
                super.image = newValue
                return
            }

            let aspectFillImage = NSImage.init(
                size: bounds.size,
                flipped: flipped) { [weak self] (destinationRect: NSRect) -> Bool in
                    let imageSize = newValue?.size as NSSize!
                    let containerSize = self!.bounds.size

                    let imageRatio = imageSize!.height / imageSize!.width
                    let containerRatio = containerSize.height / containerSize.width

                    var destinationSize = imageSize!

                    if imageRatio < containerRatio {
                        destinationSize.width = imageSize.height / containerRatio
                    } else {
                        destinationSize.height = imageSize.width * containerRatio
                    }

                    let sourceRect = NSRect(
                        x: imageSize.width / 2.0 - destinationSize.width / 2.0,
                        y: imageSize.height / 2.0 - destinationSize.height / 2.0,
                        width: destinationSize.width,
                        height: destinationSize.height
                    )

                    NSGraphicsContext.currentContext()?.imageInterpolation = .High

                    newValue!.drawInRect(
                        destinationRect,
                        fromRect: sourceRect,
                        operation: .CompositeCopy,
                        fraction: 1.0
                    )

                    return true
            }

            aspectFillImage.cacheMode = .Never

            super.image = aspectFillImage
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.imageScaling = .ScaleAxesIndependently
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        super.imageScaling = .ScaleAxesIndependently
    }


}
