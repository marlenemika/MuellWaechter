//
//  SelectedImageView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI

struct SelectedImageView: View {
    @Binding var image: Image?
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
