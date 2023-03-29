//
//  ContentView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.10
    
    @State private var isImageTaken = false
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ViewfinderView(image: $model.viewfinderImage)
                    .overlay(alignment: .top) {
                        buttonsView()
                            .frame(height: geometry.size.height * (Self.barHeightFactor+0.075))
                            .background(.black.opacity(0.7))
                    }
                    .overlay(alignment: .bottom) {
                        Text("Test").foregroundColor(.pink)
                            .frame(height: geometry.size.height * (Self.barHeightFactor+0.075))
                            .background(.black.opacity(0.7))
                    }
                    .background(.black)
            }
            .task {
                await model.camera.start()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
            .onAppear(){
                UIApplication.shared.isIdleTimerDisabled = true
            }.onDisappear(){
                UIApplication.shared.isIdleTimerDisabled = false
            }
            
        }
    }
    
    private func buttonsView() -> some View {
        HStack() {
            Spacer()
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }.frame(maxWidth: .leastNormalMagnitude, alignment: .trailing)
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}
