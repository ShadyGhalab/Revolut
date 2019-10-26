//
//  CurrencyRatesFeed .swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

struct CurrencyRatesFeed: Feed {
    typealias JSONResponseStructure = [String: Double]

    let absolutePath: String
    let parameters: [[String: Any]]?

    init(absolutePath: String, parameters: [[String: Any]]?) {
        self.absolutePath = absolutePath
        self.parameters = parameters
    }
}
