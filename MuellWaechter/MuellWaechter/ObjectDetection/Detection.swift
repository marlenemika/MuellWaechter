//
//  Detection.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 08.05.23.
//

import AVFoundation
import Vision
import CoreImage


class Detection {
    var request: VNCoreMLRequest!
    var ready: Bool = false
    private var objectsBiov2: [String] = ["feather", "flower", "egg", "kitchen paper", "apple", "foliage", "soil", "egg carton", "orange", "bone"]
    private var objectsNonBiov2: [String] = ["cigarette", "pill", "plastic cup", "plastic bag", "glass", "face mask", "ceramic", "can", "battery", "stone"]
    
    init(){
        Task {self.initialise()}
    }
    
    func initialise() {
        do {
            var model: VNCoreMLModel
            if UserDefaults.standard.integer(forKey: "modelId") == 1 {
                model = try VNCoreMLModel(for: yolov7(configuration: MLModelConfiguration()).model)
            }
            else if UserDefaults.standard.integer(forKey: "modelId") == 2 {
                model = try VNCoreMLModel(for: _2yolov7(configuration: MLModelConfiguration()).model)
            }
            else {
                exit(0)
            }
            self.request = VNCoreMLRequest(model: model)
            self.ready = true
        }
        catch {
            print(error)
        }
    }
    
    // https://www.neuralception.com/detection-app-tutorial-detector/
    // https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml/
    func detect(image: CIImage, useCase: Int) -> [DetectedObject] {
        // save all predictions in a list in case if there are more
        var detectedObjects: [DetectedObject] = []
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: image)
        
        do {
            // perform detection
            try imageRequestHandler.perform([self.request])
            let results = self.request.results!
            
            // extract detections and transform coordinates
            for observation in results where observation is VNRecognizedObjectObservation {
                let objectObservation = observation as! VNRecognizedObjectObservation
                
                let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(image.extent.size.width), Int(image.extent.size.height))
                
                let transformedBounds = CGRect(x: objectBounds.minX, y: image.extent.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
                
                let label = objectObservation.labels.first!.identifier
                
                let detectedObject = DetectedObject(label: label, confidence: objectObservation.confidence, rectangle: transformedBounds)
                
                // ignore objects that are detected as organic waste when user chose to check his organic waste (and only non-organic waste objects need to be identified)
                if ((label == "1" || objectsBiov2.contains(label)) && useCase == 1) {
                    continue
                } else {
                    detectedObjects.append(detectedObject)
                }
            }
        }
        catch {
            print(error)
        }
        return detectedObjects
    }
}

struct DetectedObject {
    var label: String
    var confidence: Float
    var rectangle: CGRect
}
