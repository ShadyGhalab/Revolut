//
//  CurrencyProvider.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import os.log

protocol CurrencyProviding {
    func allCurrenciesData() -> CurrenciesData?
}

struct CurrencyProvider: CurrencyProviding {

    private let responseDecoder: DataResponseDecoding
    private let resourceName: String
    private let bundle: Bundle

    init(responseDecoder: DataResponseDecoding = DataResponseDecoder(), resourceName: String = "CurrenciesData", bundle: Bundle = Bundle.main) {
        self.responseDecoder = responseDecoder
        self.resourceName = resourceName
        self.bundle = bundle
    }

    func allCurrenciesData() -> CurrenciesData? {
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            fatalError("Failed to locate the json file")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let currenciesData: CurrenciesData = try responseDecoder.decodeModel(from: data)

            return currenciesData
        } catch let error {
            os_log("Failed to fetch the currencies data with error: %@", log: .modelsLogger,
                   type: .error, error.localizedDescription)

            return nil
        }
    }
}
