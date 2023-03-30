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
    
    @State var useCase: Int = -1
    
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
                let labeledImage = labeler.labelImage(image: UIImage(ciImage: image), observations: observations)!
                viewfinderImage = Image(uiImage: labeledImage)
                camera.isPreviewPaused = false
                
            }
        }
    }
    
    func handlePhotoPreview(image: CIImage, useCase: Int) {
        let observations = self.detector.detectAndProcess(image: image, useCase: useCase)
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

