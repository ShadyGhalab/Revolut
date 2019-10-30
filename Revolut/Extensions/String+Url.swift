//
//  String+Url.swift
//  Revolut
//
//  Created by Shady Mustafa on 26.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

extension String {
    var isValidUrl: Bool {
        guard let url = URL(string: self) else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: self)
    }
}
