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
    
    func initialise(){
        do {
            var model: VNCoreMLModel?
            if UserDefaults.standard.integer(forKey: "modelId") == 1 {
                model = try VNCoreMLModel(for: yolov7(configuration: MLModelConfiguration()).model)
            }
            else if UserDefaults.standard.integer(forKey: "modelId") == 2 {
                model = try VNCoreMLModel(for: _2yolov7(configuration: MLModelConfiguration()).model)
            }

            self.request = VNCoreMLRequest(model: model!)
            self.ready = true
        } catch let error {
            fatalError("failed to setup model: \(error)")
        }
    }
    
    // https://www.neuralception.com/detection-app-tutorial-detector/
    // https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml/
    func detectAndProcess(image: CIImage, useCase: Int) -> [DetectedObject] {
        let observations = self.detect(image: image)
        
        let processedObservations = self.processObservation(observations: observations, viewSize: image.extent.size, useCase: useCase)
        
        return processedObservations
    }
    
    // perform detection
    func detect(image: CIImage) -> [VNObservation] {
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([self.request])
            let observations = self.request.results!
            
            return observations
        } catch let error {
            fatalError("failed to detect: \(error)")
        }
    }
    
    // extract detections and transform coordinates
    func processObservation(observations: [VNObservation], viewSize: CGSize, useCase: Int) -> [DetectedObject] {
        var processedObservations: [DetectedObject] = []
        
        for observation in observations where observation is VNRecognizedObjectObservation {
            
            let objectObservation = observation as! VNRecognizedObjectObservation
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(viewSize.width), Int(viewSize.height))
            
            let flippedBox = CGRect(x: objectBounds.minX, y: viewSize.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let label = objectObservation.labels.first!.identifier
            
            let processedOD = DetectedObject(label: label, confidence: objectObservation.confidence, rectangle: flippedBox)
            
            // ignore objects that are detected as organic waste when user chose to check his organic waste (and only non-organic waste objects need to be identified)
            if ((label == "1" || objectsBiov2.contains(label)) && useCase == 1) {
                continue
            } else {
                processedObservations.append(processedOD)
            }
        }
        return processedObservations
    }
}

struct DetectedObject {
    var label: String
    var confidence: Float
    var rectangle: CGRect
}
