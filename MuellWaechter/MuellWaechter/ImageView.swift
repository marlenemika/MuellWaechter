//
//  ImageView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var model = DataModel()
    
    @State var picture: Data?
    @State var showLoadingScreen: Bool = false
    @State var isRotating: Double = 0.0
    
    var body: some View {
        NavigationView {
            if(!showLoadingScreen){
                VStack(spacing: 50) {
                    Text("Bild wird analysiert...").fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            } else {
                GeometryReader { geometry in
                    SelectedImageView(image: $model.selectionImage)
                }
            }
        }.task {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if(model.detector.ready) {
                    model.handlePhotoPreview(image: CIImage(data: picture!)!)
                    showLoadingScreen = true
                    timer.invalidate()
                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
