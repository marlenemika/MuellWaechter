//
//  TermsConditionsView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 13.06.23.
//

import SwiftUI

struct TermsConditionsView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    Text("Durch die Nutzung dieser iOS-App stimmen Sie den folgenden Bedingungen zu:\nDiese App ist nur für den persönlichen Gebrauch bestimmt. Sie dürfen die App nicht für kommerzielle Zwecke nutzen. Sie dürfen die App nicht dekompilieren, disassemblieren oder auf andere Weise versuchen, den Quellcode der App zu ermitteln. Sie dürfen die App nicht in einer Weise nutzen, die gegen geltende Gesetze oder Vorschriften verstößt. Sie dürfen keine Inhalte in der App veröffentlichen, die verleumderisch, beleidigend oder anderweitig unangemessen sind. Wir behalten uns das Recht vor, die App jederzeit ohne Vorankündigung zu ändern oder einzustellen. Wir haften nicht für Schäden, die durch die Nutzung der App entstehen können. Durch die Nutzung der App erklären Sie sich damit einverstanden, dass wir personenbezogene Daten von Ihnen erfassen und nutzen dürfen, wie in unserer Datenschutzrichtlinie beschrieben.")
                } header: {
                    Text(" ")
                }
            }
        }.padding()
        .navigationTitle("Nutzungsbedingungen")
    }
}
