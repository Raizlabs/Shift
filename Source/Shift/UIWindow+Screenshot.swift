//
//  UIWindow+Screenshot.swift
//  Shift
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright 2015 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation


extension UIWindow {

    public class func screenshot() -> UIImage {

        // Generate image size depending on device orientation
        let imageSize: CGSize = UIScreen.mainScreen().bounds.size

        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()

        // Draw view hierarchy
        drawWindow(inContext: context, imageSize: imageSize)

        // Grab rendered image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    class func drawWindow(inContext context: CGContextRef?, imageSize: CGSize) -> Void {
        if let context = context {
            for window in UIApplication.sharedApplication().windows {
                // Save the current graphics state
                CGContextSaveGState(context)

                // draw view hierarchy or render
                if window.respondsToSelector(Selector("drawViewHierarchyInRect:")) {
                    window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
                }
                else {
                    window.layer.renderInContext(context)
                }
                CGContextRestoreGState(context)
            }
        }
        else {
            // Log an error message in case of failure
            debugPrint("unable to get current graphics context")
        }
    }

    class func rotateContext(context context: CGContextRef, imageSize: CGSize) -> Void {
        let pi_2 = CGFloat(M_PI_2)
        let pi = CGFloat(M_PI)

        switch UIApplication.sharedApplication().statusBarOrientation {
        case .LandscapeLeft:
            // Rotate graphics context 90 degrees clockwise
            CGContextRotateCTM(context, pi_2)

            // Move graphics context up
            CGContextTranslateCTM(context, 0, -imageSize.width)

        case .LandscapeRight:
            // Rotate graphics context 90 degrees counter-clockwise
            CGContextRotateCTM(context, -pi_2)

            // Move graphics context left
            CGContextTranslateCTM(context, -imageSize.height, 0)

        case .PortraitUpsideDown:
            // Rotate graphics context 180 degrees
            CGContextRotateCTM(context, pi)

            // Move graphics context left and up
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height)

        default:
            break
        }
    }

}
