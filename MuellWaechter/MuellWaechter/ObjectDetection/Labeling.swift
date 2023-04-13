//
//  Labeling.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.22.
//

import Foundation
import SwiftUI

class Labeling{
    
    private var labelColors: [String: CGColor] = [:]
    let labels = ["non-organic waste", "organic waste"]
    
    init(){
        self.labelColors = self.generateLabelColors()
    }
    
    /// Set colours for bounding boxes
    func generateLabelColors() -> [String: CGColor] {
        let labelColor: [String: CGColor] = [labels[0]:CGColor(red: 255, green: 0, blue: 0, alpha: 1),labels[1]:CGColor(red: 0, green: 255, blue: 0, alpha: 1)]
        return labelColor
    }
    
    ///  Add detections to picture
    func labelImage(image: UIImage, observations: [ProcessedObservation]) -> UIImage?{
        // setting up context
        UIGraphicsBeginImageContext(image.size)
        // image is drawn as background in current context
        image.draw(at: CGPoint.zero)
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        for observation in observations{
            var labelColor: CGColor?
            if observation.label == "1" {
                labelColor = labelColors["organic waste"]!
            } else {
                labelColor = labelColors["non-organic waste"]
            }
            let label = String(format:"%.1f",observation.confidence*100)+"%"
            let boundingBox = observation.boundingBox
            
            self.drawBox(context: context, bounds: boundingBox, color: labelColor!)
            
            let textBounds = getTextRect(bigBox: boundingBox)
            
            self.drawTextBox(context: context, drawText: label, bounds: textBounds, color: labelColor!)
            
        }
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage
    }
    
    /// Bounding Box
    func drawBox(context: CGContext, bounds :CGRect, color: CGColor){
        context.setStrokeColor(color)
        context.setLineWidth(bounds.height*0.02)
        if bounds.height < 125 {
            context.setLineWidth(10)
        }
        context.addRect(bounds)
        context.drawPath(using: .stroke)
    }
    
    /// Text Rectangle
    func getTextRect(bigBox: CGRect) -> CGRect {
        var width: CGFloat = bigBox.width + bigBox.height*0.02
        let height: CGFloat = 50
        if bigBox.height < 125 {
            width = bigBox.width + 10
        }
        // prevent overflow
        if height > bigBox.height*0.25 {
            // give text rectangle same width as bounding box
            if bigBox.height < 125 {
                return CGRect(x: bigBox.minX - 5, y: bigBox.maxY, width: width, height: height)
            } else {
                return CGRect(x: bigBox.minX - bigBox.height*0.01, y: bigBox.maxY, width: width, height: height)
            }
        }
        // give text rectangle same width as bounding box
        if bigBox.height < 125 {
            return CGRect(x: bigBox.minX - 15, y: bigBox.maxY, width: width, height: height)
        } else {
            return CGRect(x: bigBox.minX - bigBox.height*0.01, y: bigBox.maxY - height, width: width, height: height)
        }
    }
    
    /// Text
    func drawTextBox(context: CGContext, drawText text: String, bounds: CGRect, color: CGColor) {
        
        //text box
        context.setFillColor(color)
        context.addRect(bounds)
        context.drawPath(using: .fill)
        
        //text
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica", size: 35)!
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ] as [NSAttributedString.Key : Any]
        
        text.draw(in: bounds.offsetBy(dx: bounds.width*0.05, dy: bounds.height*0.05), withAttributes: textFontAttributes)
    }
    
}
