//
//  HomeView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 29.03.23.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedItem: UIImage? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showPhotosPicker: Bool = false
    @State private var sheetPresented: Bool = false
    @State private var navigateTo: Int = -1
    @State private var isActiveBio: Bool = false
    @State private var isActiveClassify: Bool = false
    @State private var useCase: Int = -1
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            ZStack {
                colorScheme == .light ? Image("background0").resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).blur(radius: 3).opacity(0.4) : Image("background1").resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).blur(radius: 3).opacity(0.4)
                
                VStack {
                    Text("Abfallklassifizierer").font(.largeTitle).fontWeight(.bold).background(colorScheme == .light ? .white : .black).cornerRadius(10)
                    
                    
                    Menu {
                        Button("Live Ansicht") {
                            self.navigateTo = 1
                            self.isActiveBio = true
                            self.useCase = 1
                        }
                        Button("Foto aufnehmen") {
//                            self.navigateTo = 2
                            self.sourceType = .camera
                            self.showPhotosPicker = true
                            self.isActiveBio = true
                            self.useCase = 1
                        }
                        Button("Foto aus Galerie auswählen") {
//                            self.navigateTo = 2
                            self.sourceType = .photoLibrary
                            self.showPhotosPicker = true
                            self.useCase = 1
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(.primary)
                                .frame(width: 200, height: 35)
                                .cornerRadius(25)
                            Text("Überprüfe Biomüll")
                                .foregroundColor(.primary).colorInvert().fontWeight(.bold)
                    }
                    }
                    .background(
                        NavigationLink(
                            destination: returnView(num: navigateTo), isActive: $isActiveBio) {
                            }
                    )
                    .padding()
                    
                    Menu {
                        Button("Live Ansicht") {
                            self.navigateTo = 1
                            self.isActiveClassify = true
                            self.useCase = 2
                        }
                        Button("Foto aufnehmen") {
                            
                            self.sourceType = .camera
                            self.showPhotosPicker = true
                            
//                            self.isActiveClassify = true
//                            self.useCase = 2
//                            self.navigateTo = 2
                        }
                        Button("Foto aus Galerie auswählen") {
                            self.sourceType = .photoLibrary
//                            self.navigateTo = 2
                            self.showPhotosPicker = true
                            self.useCase = 2
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(.primary)
                                .frame(width: 200, height: 35)
                                .cornerRadius(25)
                            Text("Klassifiziere Objekte")
                                .foregroundColor(.primary).colorInvert().fontWeight(.bold)
                    }

                    }
                    .background(
                        NavigationLink(
                            destination: returnView(num: navigateTo), isActive: $isActiveClassify) {
                            }
                    )
                    
                    .toolbar(content: {
                        Button(action: {
                            sheetPresented = true
                        }, label: {
                            Image(systemName: "info.circle")
                        })
                    })
                }
            }
            .onAppear {
                print("appera main view")
                navigateTo = -1
            }
        }
        
        .onChange(of: sourceType, perform: { newValue in
            print("changed source type")
        })
        //.photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images, photoLibrary: .shared())
        .onChange(of: selectedItem) { newItem in
//            print(newItem?.pngData())
            Task {
                // Retrieve selected asset in the form of Data
                if let data = newItem?.pngData() {
                    selectedImageData = data
                }
                if self.useCase == 1 {
                    self.isActiveBio = true
                } else if self.useCase == 2 {
                    self.isActiveClassify = true
                }
            }
        }
        .sheet(isPresented: $showPhotosPicker, onDismiss: {
            print("dismiss")
            print(selectedImageData)
//            self.isActiveClassify = true
//            self.useCase = 2
//            self.navigateTo = 2
//            print(navigateTo)
            

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                print("image")
                print(selectedImageData)
                self.isActiveClassify = true
                self.useCase = 2
                self.navigateTo = 2
            })
            
        }, content: {
            if sourceType != nil {
                ImagePickerView(selectedImage: $selectedItem, sourceType: self.sourceType).edgesIgnoringSafeArea(.bottom)
            }
        })
        .sheet(isPresented: $sheetPresented, content: {
            NavigationView {
                VStack{
                    Text("Durch die Nutzung dieser iOS-App stimmen Sie den folgenden Bedingungen zu: Diese App ist nur für den persönlichen Gebrauch bestimmt. Sie dürfen die App nicht für kommerzielle Zwecke nutzen. Sie dürfen die App nicht dekompilieren, disassemblieren oder auf andere Weise versuchen, den Quellcode der App zu ermitteln. Sie dürfen die App nicht in einer Weise nutzen, die gegen geltende Gesetze oder Vorschriften verstößt. Sie dürfen keine Inhalte in der App veröffentlichen, die verleumderisch, beleidigend oder anderweitig unangemessen sind. Wir behalten uns das Recht vor, die App jederzeit ohne Vorankündigung zu ändern oder einzustellen. Wir haften nicht für Schäden, die durch die Nutzung der App entstehen können. Durch die Nutzung der App erklären Sie sich damit einverstanden, dass wir personenbezogene Daten von Ihnen erfassen und nutzen dürfen, wie in unserer Datenschutzrichtlinie beschrieben.")
                        .padding()
                        .toolbar(content: {
                            Button(action: {
                                sheetPresented = false
                            }, label: {
                                Text("Done")
                            })
                    }).navigationTitle("Terms & Conditions")
                }
            }
        })
    }
    
    @ViewBuilder
    func returnView(num: Int) -> some View {
        switch(num){
        case 1:
            ContentView()
        case 2:
            ImageView(picture: selectedImageData)
        default:
            EmptyView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
