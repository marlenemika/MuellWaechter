//
//  ImageView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI
import SwiftUIGIF

struct ImageView: View {
    @StateObject private var model = DataModel()
    @Environment(\.dismiss) var dismiss
    
    @State var picture: Data?
    @State var showLoadingScreen: Bool = false
    @State var isRotating: Double = 0.0
    
    var body: some View {
        NavigationView {
            if(!showLoadingScreen) {
                VStack(alignment: .center) {
                    Text("Bild wird analysiert...").fontWeight(.bold)
                        .padding(.top, 250)
                    GIFImage(name: "LoadingPop")
                        .frame(width: 100)
                }
            } else {
                GeometryReader { geometry in
                    SelectedImageView(image: $model.selectionImage)
                }
            }
        }.task {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if(model.detector.ready) {
                    if(picture != nil) {
                        model.handlePhotoPreview(image: CIImage(data: picture!)!)
                        showLoadingScreen = true
                        timer.invalidate()
                    }
                }
            }
        }
        .onAppear {
            if (picture == nil) {
                dismiss()
            }
        }
        .onDisappear {
            picture = nil
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
