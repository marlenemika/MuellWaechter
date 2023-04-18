//
//  String+localize.swift
//  MuellWaechter
//
//  Created by Marlene Mika on 18.04.23.
//

import Foundation

extension String {
    func localize() -> String {
        NSLocalizedString(self, comment: "")
    }
}
