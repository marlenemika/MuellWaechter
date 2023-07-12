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
    @State private var navigateTo: Int = -1
    @State private var isActiveBio: Bool = false
    @State private var isActiveClassify: Bool = false
    @State private var useCase: Int = -1
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showInfoFirst: Bool = false
    @State private var showInfoSecond: Bool = false
    @State private var showObjects: Bool = false
    @State private var showSettings: Bool = false
    @State private var id: Int = UserDefaults.standard.value(forKey: "modelId") == nil ? 1 : UserDefaults.standard.integer(forKey: "modelId")
    
    private var objectsBiov1: [String] = ["Apfel", "Eierkarton", "Eierschale", "Feder", "Gras", "Küchenpapier", "Laub", "Orangenschale", "Sonnenblume\n"]
    private var objectsNonBiov1: [String] = ["Aludose", "Batterie","Gesichtsmaske", "Glas", "Keramikteller", "Kieselstein", "Plastikbecher", "Plastiktüte", "Tablette", "Zigarettenstümmel\n"]
    private var objectsBiov2: [String] = ["Apfel", "Eierkarton", "Eierschale", "Blumenerde", "Feder", "Knochen", "Küchenpapier", "Laub", "Orangenschale", "Sonnenblume\n"]
    private var objectsNonBiov2: [String] = ["Aludose", "Batterie", "Glas", "Gesichtsmaske", "Keramikteller", "Kieselstein", "Plastikbecher", "Plastiktüte", "Tablette", "Zigarettenstümmel\n"]
    
    var body: some View {
        if UIApplication.isFirstLaunch() {}
        
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
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            Button(action: {
                                showSettings = true
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .fill()
                                        .foregroundColor(.primary)
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(25)
                                    Image(systemName: "gear")
                                        .foregroundColor(.primary).colorInvert()
                                }
                            })
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
                        }.padding(.bottom, 100)
                    }

                }
            }
            .onAppear {
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
        .sheet(isPresented: $showSettings, content: {
            NavigationView {
                    VStack {
                        List {
                            Section {
                                Picker("Version KI", selection: $id) {
                                    Text("Version 1").tag(1)
                                    Text("Version 2").tag(2)
                                }
                                Text("**Hinweis**\nBeide KI-Modelle verfügen über eine unterschiedliche Liste an erkannten Objekten. Diese kann auf dem HomeScreen unter **Objektübersicht** aufgerufen werden.")
                            } header: {
                                Text("Einstellungen")
                            }
                            NavigationLink(destination: ImprintView()) {
                                VStack {
                                    Text("Impressum")
                                }
                            }
                            NavigationLink(destination: TermsConditionsView()) {
                                VStack {
                                    Text("Nutzungsbedingungen")
                                }
                            }
                            NavigationLink(destination: DisclaimerView()) {
                                VStack {
                                    Text("Haftungsausschluss")
                                }
                            }
                        }
                        Spacer()
                        
                        HStack {
                            Image("IW").resizable().scaledToFit()
                            Image("digital").resizable().scaledToFit().padding()
                            Image("BW").resizable().scaledToFit()
                        }
                    }.padding()
                .navigationTitle("Einstellungen")
                .toolbar(content: {
                    Button {
                        showSettings = false
                    } label: {
                        Text("Fertig")
                    }
                })
            }
        }).onChange(of: id, perform: { newValue in
            UserDefaults.standard.set(newValue, forKey: "modelId")
        })
        .sheet(isPresented: $showInfoFirst, content: {
            NavigationView {
                ScrollView {
                    VStack {
                        Text("Mit dieser Funktion kann überprüft werden, ob Bio-Abfallbehälter ordentlich sortiert sind oder ob sich darin Fremdstoffe befinden. Dazu kann entweder ein bereits bestehendes Bild aus der Galerie ausgewählt werden oder ein Bild mit der Kamera aufgenommen werden. Alternativ kann auch mit einer Live-Ansicht der Biomüll auf Fremdstoffe überprüft werden.")
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
                ScrollView {
                VStack(alignment: .leading) {
                    Text("Folgende Objekte kann der MüllWächter derzeit erkennen und klassifizieren:")
                    Text("\nMomentane Version der KI: **Version \(UserDefaults.standard.integer(forKey: "modelId"))**")
                    Text("\nBiomüll Objekte").fontWeight(.bold)
                    ForEach(UserDefaults.standard.integer(forKey: "modelId") == 1 ? objectsBiov1 : objectsBiov2, id: \.self) { obj in
                        Text(obj)
                    }
                    Text("Nicht-Biomüll Objekte").fontWeight(.bold)
                    ForEach(UserDefaults.standard.integer(forKey: "modelId") == 2 ? objectsNonBiov1 : objectsNonBiov2, id: \.self) { obj in
                        Text(obj)
                    }
                    Text("Um die Version der KI zu ändern, besuchen Sie bitte die **App-Einstellungen**.")
                }.padding()
            }
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

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if UserDefaults.standard.object(forKey: "modelId") == nil {
            UserDefaults.standard.set(1, forKey: "modelId")
            return true
        }
        return false
    }

}
