//
//  DataModel.swift
//  WasteGuard
//
//  Created by Marlene Mika on 08.05.23.
//
// https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview

import AVFoundation
import SwiftUI

final class DataModel: ObservableObject {
    let camera = Camera()
    let detection = Detection()
    let labeling = Labeling()
    
    @Published var selectedImage: Image?
    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var observationInformation: String = ""
    @Published var useCase: Int?
    
    private var objectsBiov2: [String] = ["feather", "flower", "egg", "kitchen paper", "apple", "foliage", "soil", "egg carton", "orange", "bone"]
    private var objectsNonBiov2: [String] = ["cigarette", "pill", "plastic cup", "plastic bag", "glass", "face mask", "ceramic", "can", "battery", "stone"]
    
    func handleCameraPreviews(useCase: Int) async {
        let imageStream = camera.previewStream
            .map { $0 }
        
        for await image in imageStream {
            Task { @MainActor in
                
                if !detection.ready {
                    viewfinderImage = image.image
                    return
                }
                
                camera.isPreviewPaused = true
                let detections = self.detection.detect(image: image, useCase: useCase)
                adjustObservationsInfo(observations: detections)
                let annotatedImage = labeling.drawBoundingBoxAndTextLabel(detections: detections, image: UIImage(ciImage: image))
                viewfinderImage = Image(uiImage: annotatedImage)
                camera.isPreviewPaused = false
                
            }
        }
    }
    
    func handlePhotoPreview(image: CIImage, useCase: Int) {
        let detections = self.detection.detect(image: image, useCase: useCase)
        adjustObservationsInfo(observations: detections)
        let annotatedImage = labeling.drawBoundingBoxAndTextLabel(detections: detections, image: UIImage(ciImage: image))
        selectedImage = Image(uiImage: annotatedImage)
    }
    
    private func adjustObservationsInfo(observations: [DetectedObject]) {
        // version 1 of the model only provides whether the detected object is organic waste or not
        if UserDefaults.standard.integer(forKey: "modelId") == 1 {
            // only non-organic waste detected
            if observations.contains(where: { $0.label == "0" }) && !observations.contains(where: { $0.label == "1" }) {
                // check bio waste
                if useCase == 1 {
                    observationInformation = observations.count == 1 ? "Beim markierten Objekt handelt es sich um Nicht-Biomüll.\n Bitte markiertes Objekt aus dem Biomüll entfernen.\n" : "Bei den markierten Objekten handelt es sich um Nicht-Biomüll.\nBitte markierte Objekte aus dem Biomüll entfernen.\n"
                } else if useCase == 2 {
                    observationInformation = observations.count == 1 ? "Beim markierten Objekt handelt es sich um Nicht-Biomüll.\n" : "Bei den markierten Objekten handelt es sich um Nicht-Biomüll.\n"
                }
            }
            
            // only organic waste detected
            if observations.contains(where: { $0.label == "1" }) && !observations.contains(where: { $0.label == "0" }) {
                // classify objects
                if useCase == 2 {
                    observationInformation = observations.count == 1 ? "Beim markierten Objekt handelt es sich um Biomüll.\n" : "Bei den markierten Objekten handelt es sich um Biomüll.\n"
                }
            }
            
            // both organic and non-organic waste detected
            if observations.contains(where: { $0.label == "1" }) && observations.contains(where: { $0.label == "0" }) {
                // classify objects
                if useCase == 2 {
                    let greenObjectsCount = observations.filter { $0.label == "1" }.count
                    let redObjectsCount = observations.filter { $0.label == "0" }.count
                    let greenObjectText = greenObjectsCount == 1 ? "Beim grün markierten Objekt handelt es sich um Biomüll.\n" : "Bei den grün markierten Objekten handelt es sich um Biomüll.\n"
                    let redObjectText = redObjectsCount == 1 ? "Beim rot markierten Objekt handelt es sich um Nicht-Biomüll." : "Bei den rot markierten Objekten handelt es sich um Nicht-Biomüll."
                    observationInformation = "\(greenObjectText)\(redObjectText)"
                }
            }
            
            // neither organic nor non-organic waste detected
            if !observations.contains(where: { $0.label == "1" }) && !observations.contains(where: { $0.label == "0" }) {
                // check bio waste
                if useCase == 1 {
                    observationInformation = "Es wurden keine Fremdstoffe im Müll erkannt.\n"
                } else if useCase == 2 {
                    observationInformation = "Es wurden keine Objekte erkannt.\n"
                }
            }
        }
        // version 2 of the model provides more information about the detected object
        else if UserDefaults.standard.integer(forKey: "modelId") == 2 {
            // only non-organic waste detected
            if observations.allSatisfy({ objectsNonBiov2.contains($0.label) }) && !observations.isEmpty {
                // check bio waste
                if useCase == 1 {
                    let objects = observations.map { translateLabels(label: $0.label) }
                    let objectsSet = Array(Set(objects))
                    observationInformation = objects.count == 1 ? "Erkanntes Objekt: \(objectsSet.joined(separator: ", "))\nBitte markiertes Objekt aus dem Biomüll entfernen.\n" : "Erkannte Objekte: \(objectsSet.joined(separator: ", "))\nBitte alle markierten Objekte aus dem Biomüll entfernen.\n"
                } else if useCase == 2 {
                    let objects = observations.map { translateLabels(label: $0.label) }
                    let objectsSet = Array(Set(objects))
                    observationInformation = objects.count == 1 ? "Erkanntes Objekt: \(objectsSet.joined(separator: ", "))\nBeim markierten Objekt handelt es sich um Nicht-Biomüll.\n" : "Erkannte Objekte: \(objectsSet.joined(separator: ", "))\nBei allen markierten Objekten handelt es sich um Nicht-Biomüll.\n"
                }
            }
            // only organic waste detected
            else if observations.allSatisfy({ objectsBiov2.contains($0.label) }) && !observations.isEmpty {
                // classify objects
                if useCase == 2 {
                    let objects = observations.map { translateLabels(label: $0.label) }
                    let objectsSet = Array(Set(objects))
                    observationInformation = objects.count == 1 ? "Erkanntes Objekt: \(objectsSet.joined(separator: ", "))\nBeim markierten Objekt handelt es sich um Biomüll.\n" : "Erkannte Objekte: \(objectsSet.joined(separator: ", "))\nBei allen markierten Objekten handelt es sich um Biomüll.\n"
                }
            }
            // both organic and non-organic waste detected
            else if observations.contains(where: { objectsBiov2.contains($0.label) }) && observations.contains(where: { objectsNonBiov2.contains($0.label) }) && !observations.isEmpty {
                // classify objects
                if useCase == 2 {
                    var bioObjects: [String] = []
                    var nonBioObjects: [String] = []
                    observations.forEach { observation in
                        if objectsBiov2.contains(observation.label) {
                            bioObjects.append(translateLabels(label: observation.label))
                        } else if objectsNonBiov2.contains(observation.label) {
                            nonBioObjects.append(translateLabels(label: observation.label))
                        }
                    }
                    let bioObjectsSet = Array(Set(bioObjects))
                    let nonBioObjectsSet = Array(Set(nonBioObjects))
                    let bioObjectText = bioObjects.count == 1 ? "Beim folgenden (grün markierten) Objekt handelt es sich um Biomüll: \(bioObjectsSet.joined(separator: ", "))\n" : "Bei den folgenden (grün markierten) Objekten handelt es sich um Biomüll: \(bioObjectsSet.joined(separator: ", "))\n"
                    let nonBioObjectText = nonBioObjects.count == 1 ? "Beim folgenden (rot markierten) Objekt handelt es sich um Nicht-Biomüll: \(nonBioObjectsSet.joined(separator: ", "))\n" : "Bei den folgenden (rot markierten) Objekten handelt es sich um Nicht-Biomüll: \(nonBioObjectsSet.joined(separator: ", "))\n"
                    observationInformation = "\(bioObjectText)\(nonBioObjectText)"
                }
            }
            // neither organic nor non-organic waste detected
            else if observations.isEmpty {
                // check bio waste
                if useCase == 1 {
                    observationInformation = "Es wurden keine Fremdstoffe im Müll erkannt.\n"
                    // classify objects
                } else if useCase == 2 {
                    observationInformation = "Es wurden keine Objekte erkannt.\n"
                }
            }
        }
    }

    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        if !self.detection.ready {
            return nil
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let image = CIImage(data: imageData, options: [.applyOrientationProperty: true]) else {return nil}
        
        let observations = self.detection.detect(image: image, useCase: -1)
        let annotatedImage = labeling.drawBoundingBoxAndTextLabel(detections: observations, image: UIImage(ciImage: image))
        
        let thumbnailImage = Image(uiImage: annotatedImage)
        return PhotoData(thumbnailImage: thumbnailImage, imageData: imageData)
    }
    
    private func translateLabels(label: String) -> String {
        var germanLabel: String
        switch label {
            // organic waste
        case "feather": germanLabel = "Feder"
        case "flower": germanLabel = "Sonnenblume"
        case "egg": germanLabel = "Eierschale"
        case "kitchen paper": germanLabel = "Küchenpapier"
        case "apple": germanLabel = "Apfel"
        case "foliage": germanLabel = "Laub"
        case "soil": germanLabel = "Blumenerde"
        case "egg carton": germanLabel = "Eierschachtel"
        case "orange": germanLabel = "Orangenschale"
        case "bone": germanLabel = "Knochen"
            // non-organic waste
        case "cigarette": germanLabel = "Zigarettenstümmel"
        case "pill": germanLabel = "Tablette"
        case "plastic cup": germanLabel = "Plastikbecher"
        case "plastic bag": germanLabel = "Plastiktüte"
        case "glass": germanLabel = "Glas"
        case "face mask": germanLabel = "Gesichtsmaske"
        case "ceramic": germanLabel = "Keramikteller"
        case "can": germanLabel = "Aludose"
        case "battery": germanLabel = "Batterie"
        case "stone": germanLabel = "Stein"
        default:
            germanLabel = ""
        }
        return germanLabel
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var imageData: Data
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {
    
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
