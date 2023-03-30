//
//  Coordinator.swift
//  WasteClassification
//
//  Created by Marlene Mika on 29.03.23.
//

import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.editedImage] as? UIImage {
                    self.picker.selectedImage = img
                } else if let image = info[.originalImage] as? UIImage {
                    self.picker.selectedImage = image
                }
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
