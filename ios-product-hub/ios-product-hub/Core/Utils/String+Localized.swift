//
//  String+Localized.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

extension String {
    var localized: String {
        LanguageManager.shared.localizedString(self)
    }
}
