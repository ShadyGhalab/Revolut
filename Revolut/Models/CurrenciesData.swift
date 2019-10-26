//
//  CurrenciesData.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

struct CurrenciesData: Codable {
    let currencies: [Currency]
}

struct Currency: Codable, Equatable {
    let imageName: String
    let code: String
    let name: String
}
