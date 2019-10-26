//
//  AddCurrencyPairViewModel.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

protocol AddCurrencyPairViewInputs { }

protocol AddCurrencyPairViewOutputs {
    var titleLabelLocalizedText: String { get }
    var descriptionLabelLocalizedText: String { get }
    var currencies: [Currency] { get }
}

protocol AddCurrencyPairViewProtocol: Any {
    var inputs: AddCurrencyPairViewInputs { get }
    var outputs: AddCurrencyPairViewOutputs { get }
}

struct AddCurrencyPairViewModel: AddCurrencyPairViewInputs, AddCurrencyPairViewOutputs, AddCurrencyPairViewProtocol {

    var inputs: AddCurrencyPairViewInputs { return self }
    var outputs: AddCurrencyPairViewOutputs { return self }

    init(currencyProvider: CurrencyProviding = CurrencyProvider()) {
        titleLabelLocalizedText = "revolut.addCurrencyPair.title".localized
        descriptionLabelLocalizedText = "revolut.addCurrencyPair.description".localized
        currencies = currencyProvider.allCurrenciesData().map { $0.currencies } ?? []
    }

    // Outputs
    let titleLabelLocalizedText: String
    let descriptionLabelLocalizedText: String
    let currencies: [Currency]
}
