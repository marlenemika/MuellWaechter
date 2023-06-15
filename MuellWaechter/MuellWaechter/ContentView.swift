//
//  ContentView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var model = DataModel()
    
    @State var useCase: Int
    @State private var isImageTaken: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                ViewfinderView(image: $model.viewfinderImage)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .size(width: 500, height: 150)
                            .fill(colorScheme == .light ? Color(.white).opacity(0.7) : Color(.black).opacity(0.7))
                    }
                    
                    Text(model.observationInformation)
                        .padding()
            }
            .toolbar(content: {
                Button {
                    model.camera.switchCaptureDevice()
                } label: {
                    Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(colorScheme == .light ? Color(.black) : Color(.white))
                }
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
            })
            .task {
                model.useCase = useCase
                await model.camera.start()
                await model.handleCameraPreviews(useCase: useCase)
            }
            .ignoresSafeArea()
            .navigationTitle("Live Ansicht")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                UIApplication.shared.isIdleTimerDisabled = true
            }.onDisappear(){
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}
