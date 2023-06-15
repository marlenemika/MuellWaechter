//
//  ImprintView.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 13.06.23.
//

import SwiftUI

struct ImprintView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    Text("arborsys GmbH\nVertretungsberechtigter Geschäftsführer: Steffen Baumgartner\nInsel 3\n89231 Neu-Ulm")
                } header: {
                    Text("Anbieterkennzeichnung gem. § 5 TMG")
                }
                Section {
                    Text("Telefon: +49 (0) 731 / 49 39 16- 50\nE-Mail: info@arborsys.de")
                } header: {
                    Text("Kontaktdaten")
                }
                Section {
                    Text("DE292016588")
                } header: {
                    Text("Umsatzsteuer-ID")
                }
                Section {
                    Text("Eintragung im Registergericht: Amtsgericht Memmingen\nRegisternummer: HRB 17561\nSitz der Gesellschaft: Neu-Ulm")
                } header: {
                    Text("Registereintrag")
                }
                Section {
                    Text("**Haftung für Inhalte**\nDie Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.")
                    Text("**Urheberrecht**\nDie durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet. Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen.")
                } header: {
                    Text("Haftungsausschluss")
                }
            }
        }.navigationTitle("Impressum")
    }
}
