//
//  Labeling.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 10.05.23.
//

import Foundation
import UIKit

class Labeling {
    private var objectsBiov2: [String] = ["feather", "flower", "egg", "kitchen paper", "apple", "foliage", "soil", "egg carton", "orange", "bone"]
    private var objectsNonBiov2: [String] = ["cigarette", "pill", "plastic cup", "plastic bag", "glass", "face mask", "ceramic", "can", "battery", "stone"]
    
    let modelId = UserDefaults.standard.integer(forKey: "modelId")
    
    func drawBoundingBoxAndTextLabel(detections: [DetectedObject], image: UIImage) -> UIImage {
        let imageSize = image.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        image.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()
        
        for detection in detections {
            var colour: CGColor?
            // differentiate between model version
            if modelId == 1 {
                // set colour of bounding box
                colour = detection.label == "0" ? CGColor(red: 255, green: 0, blue: 0, alpha: 1) : CGColor(red: 0, green: 255, blue: 0, alpha: 1)
            }
            
            else if modelId == 2 {
                // set colour of bounding box
                colour = objectsNonBiov2.contains(detection.label) ? CGColor(red: 255, green: 0, blue: 0, alpha: 1) : CGColor(red: 0, green: 255, blue: 0, alpha: 1)
            }
            
            let boundingBox = detection.rectangle
            
            // draw bounding box
            self.drawBoundingBox(context: context, boundingBox: boundingBox, colour: colour!)
            
            // confidence score in percentage
            let confidence = String(format: "%.1f", detection.confidence * 100) + "%"
            
            self.drawTextLabel(context: context, boundingBox: boundingBox, colour: colour!, confidence: confidence)
            
        }
        
        // save context as UIImage
        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return modifiedImage!
    }
    
    func drawBoundingBox(context: CGContext?, boundingBox: CGRect, colour: CGColor?) {
        context?.setStrokeColor(colour!)
        
        // adjust border width so that object is not hidden (especially for small bounding boxes)
        if boundingBox.height < 125 {
            context?.setLineWidth(10)
        }
        else {
            context?.setLineWidth(boundingBox.height * 0.02)
        }
        context?.addRect(boundingBox)
        context?.strokePath()
    }
    
    func drawTextLabel(context: CGContext?, boundingBox: CGRect, colour: CGColor?, confidence: String) {
        let label: CGRect
        let height: CGFloat = 50
        var width: CGFloat = 0
        
        // adjust height so that label text is always readable
        if boundingBox.height < 125 {
            width = boundingBox.height * 0.25
        }
        else {
            width = boundingBox.width + boundingBox.height * 0.02
        }
        
        // give label same width as bounding box and prevent overflow
        if height > boundingBox.height * 0.25 && boundingBox.height < 125 {
            label = CGRect(x: boundingBox.minX - 5, y: boundingBox.maxY, width: width, height: height)
        } else {
            let labelX = boundingBox.minX - (boundingBox.height < 125 ? 15 : boundingBox.height * 0.01)
            let labelY = boundingBox.maxY - (height > boundingBox.height * 0.25 ? height : 0)
            label = CGRect(x: labelX, y: labelY, width: width, height: height)
        }
        
        // draw text box
        context?.setFillColor(colour!)
        context?.addRect(label)
        context?.fill(label)

        // add text
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica", size: 35)!
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ] as [NSAttributedString.Key : Any]
        confidence.draw(in: label.offsetBy(dx: boundingBox.width * 0.05, dy: 0), withAttributes: textFontAttributes)
    }
}
