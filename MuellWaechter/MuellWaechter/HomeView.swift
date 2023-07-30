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
    @State private var showTACAgreement: Bool = !UserDefaults.standard.bool(forKey: "agreedTAC")
    @State private var agreedToggle: Bool = false
    @State private var agreedToggle2: Bool = false
    
    private var objectsBiov1: [String] = ["Apfel", "Blumenerde", "Eierkarton", "Eierschale", "Feder", "Küchenpapier", "Laub", "Orangenschale", "Sonnenblume\n"]
    private var objectsNonBiov1: [String] = ["Aludose", "Batterie","Gesichtsmaske", "Glas", "Keramikteller", "Kieselstein", "Plastikbecher", "Plastiktüte", "Tablette", "Zigarettenstümmel\n"]
    private var objectsBiov2: [String] = ["Apfel", "Blumenerde", "Eierkarton", "Eierschale", "Feder", "Knochen", "Küchenpapier", "Laub", "Orangenschale", "Sonnenblume\n"]
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
        
        .sheet(isPresented: $showTACAgreement, content: {
            ScrollView {
            VStack {
                Text("Willkommen beim **MüllWächter**!")
                    .font(.title).padding().frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(.center)
                    
                Text("Der MüllWächter verwendet eine Künstliche Intelligenz, weswegen es zu fehlerhaften Antworten kommen kann. Bevor Sie den MüllWächter benutzen, lesen Sie bitte die Nutzungsbedingungen und den Haftungsausschluss sorgfältig durch.")
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Collapsible(
                    label: { Text("Nutzungsbedingungen") },
                    content: {
                        Text("Durch die Nutzung dieser iOS-App stimmen Sie den folgenden Bedingungen zu:\nDiese App ist nur für den persönlichen Gebrauch bestimmt. Sie dürfen die App nicht für kommerzielle Zwecke nutzen. Sie dürfen die App nicht dekompilieren, disassemblieren oder auf andere Weise versuchen, den Quellcode der App zu ermitteln. Sie dürfen die App nicht in einer Weise nutzen, die gegen geltende Gesetze oder Vorschriften verstößt. Sie dürfen keine Inhalte in der App veröffentlichen, die verleumderisch, beleidigend oder anderweitig unangemessen sind. Wir behalten uns das Recht vor, die App jederzeit ohne Vorankündigung zu ändern oder einzustellen. Wir haften nicht für Schäden, die durch die Nutzung der App entstehen können. Durch die Nutzung der App erklären Sie sich damit einverstanden, dass wir personenbezogene Daten von Ihnen erfassen und nutzen dürfen, wie in unserer Datenschutzrichtlinie beschrieben.").padding()
                    }
                ).padding()
                
                Collapsible(
                    label: { Text("Haftungsausschluss") },
                    content: {
                        VStack {
                            Text("Durch die Nutzung des **MüllWächters** erklären Sie sich mit den folgenden Bedingungen einverstanden.\n\n**Genauigkeit der Ergebnisse**\nDer **MüllWächter** ist ein Hilfsmittel, das entwickelt wurde, um Benutzern bei der Identifizierung von potenziellen Biomüllprodukten zu unterstützen. Sie sollte jedoch nicht als alleinige Grundlage für Entscheidungen über die Abfallentsorgung oder sonstige Maßnahmen herangezogen werden.\n\n**Eigenverantwortung**\nDie App bietet keine Garantie für die absolute Genauigkeit der Ergebnisse bei der Klassifizierung von Objekten als Biomüllprodukte oder Nicht-Biomüllprodukte. Die Erkennungsergebnisse basieren auf Algorithmen und maschinellem Lernen, die auf einer umfangreichen Datenbank von Objekten und deren Merkmalen beruhen. Dennoch können Fehler oder Fehlklassifikationen auftreten.\n\n**Ergänzende Informationsquelle**\nDie Entscheidung über die korrekte Entsorgung von Abfällen obliegt allein dem Benutzer. Es wird empfohlen, die von der App bereitgestellten Ergebnisse als zusätzliche Informationsquelle zu betrachten und diese mit anderen verfügbaren Informationen und den örtlichen Vorschriften zur Abfallentsorgung abzugleichen.\n\n**Haftungsausschluss für Schäden**\nDie Entwickler der App übernehmen keine Haftung für Schäden, die durch die Nutzung der App oder die Verwendung der von der App bereitgestellten Informationen entstehen. Dies schließt direkte, indirekte, zufällige, besondere oder Folgeschäden ein.\n\n**Externe Quellen und Dienste**\nDer **MüllWächter** kann auf externe Quellen oder Dienste verweisen, die von Dritten betrieben werden. Die Entwickler der App haben keine Kontrolle über solche externen Inhalte und übernehmen keine Verantwortung für deren Verfügbarkeit, Genauigkeit, Sicherheit oder Rechtmäßigkeit.\n\n**Kein Ersatz für professionelle Beratung**\nDer **MüllWächter** ersetzt nicht die Beratung durch qualifizierte Fachkräfte, Abfallexperten oder lokale Behörden. Im Zweifelsfall sollte immer auf die Empfehlungen und Vorschriften der örtlichen Abfallentsorgungsstellen zurückgegriffen werden.").multilineTextAlignment(.leading)
                        }.padding()
                    }
                )
                .padding()
                
                Divider()
                
                Toggle("Ich habe die Nutzungsbedingungen gelesen und akzeptiere diese.", isOn: $agreedToggle)
                    .multilineTextAlignment(.leading)
                    .padding()
                Toggle("Ich habe den Haftungsausschluss gelesen und bin damit einverstanden.", isOn: $agreedToggle2)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Button {
                    UserDefaults.standard.set(true, forKey: "agreedTAC")
                    showTACAgreement = false
                } label: {
                    Text("Fertig")
                }
                .disabled(!(agreedToggle && agreedToggle2))
            }.padding()
        }.interactiveDismissDisabled()
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
            UserDefaults.standard.set(false, forKey: "agreedTAC")
            UserDefaults.standard.set(1, forKey: "modelId")
            return true
        }
        return false
    }

}
