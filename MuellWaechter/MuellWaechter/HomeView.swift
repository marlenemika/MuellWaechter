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
    @State private var showInfoFirst: Bool = false
    @State private var showInfoSecond: Bool = false
    @State private var showObjects: Bool = false
    
    private var objectsBio: [String] = ["Eierschalen", "Eierkartons", "Küchenpapier", "Apfel", "Erde", "Gras", "Kaffeefilter", "Laub", "Sonnenblumen", "Federn\n"]
    private var objectsNonBio: [String] = ["Plastiktüten", "Glas", "Plastikbecher", "Coladosen", "Batterien", "Masken", "Kieselsteine", "Keramikteller", "Tabletten", "Zigarettenstümmel"]
    
    var body: some View {
        NavigationView {
            ZStack {
                colorScheme == .light ? Image("background0").resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).blur(radius: 3).opacity(0.4) : Image("background1").resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).blur(radius: 3).opacity(0.4)
                
                VStack {
                    Spacer()
                    Text("Müll Wächter").font(.largeTitle).fontWeight(.bold).background(colorScheme == .light ? .white : .black).cornerRadius(10)
                    
                    HStack {
                        Menu {
                            Button("Live Ansicht") {
                                self.navigateTo = 1
                                self.isActiveBio = true
                                self.useCase = 1
                            }
                            Button("Foto aufnehmen") {
                                self.sourceType = .camera
                                self.showPhotosPicker = true
                                self.useCase = 1
                            }
                            Button("Foto aus Galerie auswählen") {
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
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(.primary)
                                .frame(width: 35, height: 35)
                                .cornerRadius(25)
                                .opacity(0.7)
                            Text("?")
                                .foregroundColor(.primary).colorInvert().fontWeight(.bold)
                        }.onTapGesture {
                            showInfoFirst = true
                        }
                    }
                    .background(
                        NavigationLink(
                            destination: returnView(num: navigateTo), isActive: $isActiveBio) {
                            }
                    )
                    .padding()
                    
                    HStack {
                        Menu {
                            Button("Live Ansicht") {
                                self.navigateTo = 1
                                self.isActiveClassify = true
                                self.useCase = 2
                            }
                            Button("Foto aufnehmen") {
                                self.sourceType = .camera
                                self.showPhotosPicker = true
                                self.useCase = 2
                            }
                            Button("Foto aus Galerie auswählen") {
                                self.sourceType = .photoLibrary
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
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(.primary)
                                .frame(width: 35, height: 35)
                                .cornerRadius(25)
                                .opacity(0.7)
                            Text("?")
                                .foregroundColor(.primary).colorInvert().fontWeight(.bold)
                        }.onTapGesture {
                            showInfoSecond = true
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
                    Spacer()
                    Button {
                        showObjects = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill()
                                .foregroundColor(.primary)
                                .frame(width: 200, height: 35)
                                .cornerRadius(25)
                            Text("Objektübersicht")
                                .foregroundColor(.primary).colorInvert().fontWeight(.bold)
                        }.onTapGesture {
                            showObjects = true
                        }.padding(.bottom, 50)
                    }

                }
            }
            .onAppear {
                print("appear main view")
                navigateTo = -1
                selectedItem = nil
                selectedImageData = nil
            }
        }
        .onChange(of: sourceType) {newItem in print("sourceType changed")}
        
        .onChange(of: selectedItem) { newItem in
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
            
            if (selectedItem != nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    print("image")
                    print(selectedImageData)
                    self.navigateTo = 2
                })
            }
            
        }, content: {
            if sourceType != nil {
                ImagePickerView(selectedImage: $selectedItem, sourceType: self.sourceType).edgesIgnoringSafeArea(.bottom)
            }
        })
        .sheet(isPresented: $sheetPresented, content: {
            NavigationView {
                VStack {
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
        .sheet(isPresented: $showInfoFirst, content: {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("Mit dieser Funktion kann überprüft werden, ob Bio-Abfallbehälter ordentlich sortiert ist oder ob sich darin Fremdstoffe befinden. Dazu kann entweder ein bereits bestehendes Bild aus der Galerie ausgewählt werden oder ein Bild mit der Kamera aufgenommen werden. Alternativ kann auch mit einer Live-Ansicht der Biomüll auf Fremdstoffe überprüft werden.")
                        Image("checkBio")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.8)
                    }.padding()
                }
                .navigationTitle("Hilfe")
                .toolbar(content: {
                    Button {
                        showInfoFirst = false
                    } label: {
                        Text("Fertig")
                    }
                })
            }
        })
        .sheet(isPresented: $showInfoSecond, content: {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("Mit dieser Funktion können eine oder mehrere Objekte darauf überprüft werden, ob es sich jeweils um Bioabfall oder Nicht-Bioabfall handelt. Dazu kann entweder ein bereits bestehendes Bild aus der Galerie ausgewählt werden oder ein Bild mit der Kamera aufgenommen werden. Alternativ kann auch mit einer Live-Ansicht die Klassifizierung erfolgen.")
                        Image("classifyObject")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.8)
                    }.padding()
                }
                .navigationTitle("Hilfe")
                .toolbar(content: {
                    Button {
                        showInfoSecond = false
                    } label: {
                        Text("Fertig")
                    }
                })
            }
        })
        .sheet(isPresented: $showObjects, content: {
            NavigationView {
                    VStack(alignment: .leading) {
                        Text("Folgende Objekte kann der MüllWächter erkennen und klassifizieren:\n")
                        Text("Biomüll Objekte").fontWeight(.bold)
                            ForEach(objectsBio, id: \.self) { obj in
                                Text(obj)
                            }
                        Text("Nicht-Biomüll Objekte").fontWeight(.bold)
                            ForEach(objectsNonBio, id: \.self) { obj in
                                Text(obj)
                            }
                    }.padding()
                .navigationTitle("Erkannte Objekte")
                .toolbar(content: {
                    Button {
                        showObjects = false
                    } label: {
                        Text("Fertig")
                    }
                })
            }
        })
    }
    
    @ViewBuilder
    func returnView(num: Int) -> some View {
        if (num == 1) {
            ContentView(useCase: useCase)
        } else if (num == 2) {
            ImageView(useCase: useCase, picture: selectedImageData)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
