//
//  DisclaimerView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 13.06.23.
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    Text("Durch die Nutzung des **MüllWächters** erklären Sie sich mit den folgenden Bedingungen einverstanden.")
                } header: {
                    Text(" ")
                }
                Section {
                    Text("Der **MüllWächter** ist ein Hilfsmittel, das entwickelt wurde, um Benutzern bei der Identifizierung von potenziellen Biomüllprodukten zu unterstützen. Sie sollte jedoch nicht als alleinige Grundlage für Entscheidungen über die Abfallentsorgung oder sonstige Maßnahmen herangezogen werden.")
                } header: {
                    Text("Genauigkeit der Ergebnisse")
                }
                Section {
                    Text("Die App bietet keine Garantie für die absolute Genauigkeit der Ergebnisse bei der Klassifizierung von Objekten als Biomüllprodukte oder Nicht-Biomüllprodukte. Die Erkennungsergebnisse basieren auf Algorithmen und maschinellem Lernen, die auf einer umfangreichen Datenbank von Objekten und deren Merkmalen beruhen. Dennoch können Fehler oder Fehlklassifikationen auftreten.")
                } header: {
                    Text("Eigenverantwortung")
                }
                Section {
                    Text("Die Entscheidung über die korrekte Entsorgung von Abfällen obliegt allein dem Benutzer. Es wird empfohlen, die von der App bereitgestellten Ergebnisse als zusätzliche Informationsquelle zu betrachten und diese mit anderen verfügbaren Informationen und den örtlichen Vorschriften zur Abfallentsorgung abzugleichen.")
                } header: {
                    Text("Ergänzende Informationsquelle")
                }
                Section {
                    Text("Die Entwickler der App übernehmen keine Haftung für Schäden, die durch die Nutzung der App oder die Verwendung der von der App bereitgestellten Informationen entstehen. Dies schließt direkte, indirekte, zufällige, besondere oder Folgeschäden ein.")
                } header: {
                    Text("Haftungsausschluss für Schäden")
                }
                Section {
                    Text("Der **MüllWächter** kann auf externe Quellen oder Dienste verweisen, die von Dritten betrieben werden. Die Entwickler der App haben keine Kontrolle über solche externen Inhalte und übernehmen keine Verantwortung für deren Verfügbarkeit, Genauigkeit, Sicherheit oder Rechtmäßigkeit.")
                } header: {
                    Text("Externe Quellen und Dienste")
                }
                Section {
                    Text("Der **MüllWächter** ersetzt nicht die Beratung durch qualifizierte Fachkräfte, Abfallexperten oder lokale Behörden. Im Zweifelsfall sollte immer auf die Empfehlungen und Vorschriften der örtlichen Abfallentsorgungsstellen zurückgegriffen werden.")
                } header: {
                    Text("Kein Ersatz für professionelle Beratung")
                }
            }
        }.padding()
        .navigationTitle("Haftungsausschluss")
    }
}
