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
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                SelectedImageView(image: $model.selectionImage)
            }
        }.task {
            await model.handlePhotoPreview(image: CIImage(data: picture!)!)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
