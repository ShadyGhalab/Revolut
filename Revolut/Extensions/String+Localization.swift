//
//  String+Localization.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

public extension String {
    /**
     Localized version of this string using it as a key in Localizable.strings in the main Bundle.
     */
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
