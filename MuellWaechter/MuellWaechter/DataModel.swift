//
//  DataModel.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import AVFoundation
import SwiftUI

class DataModel: NSObject,ObservableObject {
    let camera = Camera()
    var detector = ObjectDetection()
    var labeler = Labeling()
    
    @Published var observationsInfo: String = ""
    @Published var useCase: Int?
    @Published var viewfinderImage: Image?
    @Published var selectionImage: Image?
    @Published var thumbnailImage: Image?
    
    var isPhotosLoaded = false
    
    func handleCameraPreviews(useCase: Int) async {
        let imageStream = camera.previewStream
            .map { $0 }

        for await image in imageStream {
            Task { @MainActor in
                
                if !detector.ready {
                    viewfinderImage = image.image
                    return
                }
                camera.isPreviewPaused = true
                let observations = self.detector.detectAndProcess(image: image, useCase: useCase)
                adjustObservationsInfo(observations: observations)
                let labeledImage = labeler.labelImage(image: UIImage(ciImage: image), observations: observations)!
                viewfinderImage = Image(uiImage: labeledImage)
                camera.isPreviewPaused = false
                
            }
        }
    }
    
    func handlePhotoPreview(image: CIImage, useCase: Int) {
        let observations = self.detector.detectAndProcess(image: image, useCase: useCase)
        adjustObservationsInfo(observations: observations)
        let labeledImage = labeler.labelImage(image: UIImage(ciImage: image), observations: observations)!
        selectionImage = Image(uiImage: labeledImage)
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
    
    private func adjustObservationsInfo(observations: [ProcessedObservation]) {
        // only non-organic waste detected
        if (observations.contains(where: { observation in
            observation.label == "0"
        }) && !(observations.contains(where: { observation in
            observation.label == "1"
        }))) {
            // check bio waste
            if (useCase == 1) {
                observationsInfo = "Bei den markierten Gegenständen handelt es sich um Nicht-Biomüll.\nBitte aus dem Biomüll entfernen.\n"
            // classify objects
            } else if (useCase == 2) {
                observationsInfo = "Bei den markierten Gegenständen handelt es sich um Nicht-Biomüll.\n"
            }
        }
        
        // only organic waste detected
        if (observations.contains(where: { observation in
            observation.label == "1"
        }) && !(observations.contains(where: { observation in
            observation.label == "0"
        }))) {
            // classify objects
            if (useCase == 2) {
                observationsInfo = "Bei den markierten Gegenständen handelt es sich um Biomüll.\n"
            }
        }
        
        // both organic and non-organic waste detected
        if (observations.contains(where: { observation in
            observation.label == "1"
        }) && (observations.contains(where: { observation in
            observation.label == "0"
        }))) {
            // classify objects
            if (useCase == 2) {
                observationsInfo = "Bei den grün markierten Gegenständen handelt es sich um Biomüll.\nBei den rot markierten Gegenständen handelt es sich um Nicht-Biomüll."
            }
        }
        
        // neither organic nor non-organic waste detected
        if (!observations.contains(where: { observation in
            observation.label == "1"
        }) && !(observations.contains(where: { observation in
            observation.label == "0"
        }))) {
            // check bio waste
            if (useCase == 1) {
                observationsInfo = "Es wurden keine Fremdstoffe im Müll erkannt.\n"
            // classify objects
            } else if (useCase == 2) {
                observationsInfo = "Es wurden keine Objekte erkannt.\n"
            }
        }
    }

    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        if !self.detector.ready { return nil}
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let detImage = CIImage(data: imageData,options: [.applyOrientationProperty:true]) else {return nil}
        
        let observations = self.detector.detectAndProcess(image: detImage, useCase: -1)
        let labeledImage = labeler.labelImage(image: UIImage(ciImage: detImage), observations: observations)!
        
        let thumbnailImage = Image(uiImage: labeledImage)
        return PhotoData(thumbnailImage: thumbnailImage, imageData: labeledImage)
    }
    
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var imageData: UIImage
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

