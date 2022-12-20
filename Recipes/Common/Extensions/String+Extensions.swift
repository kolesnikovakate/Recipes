//
//  String.swift
//  Recipes
//
//  Created by Ekaterina Kolesnikova on 12/20/22.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
