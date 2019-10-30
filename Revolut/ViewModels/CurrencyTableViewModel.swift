//
//  CurrencyTableViewModel.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import CoreData

private enum Constants {
    static let maxSelectedCurrencies: Int = 2
}

protocol CurrencyTableViewInputs {
    func userDidSelectCurrency(at index: Int)
}

protocol CurrencyTableViewOutputs {
    var userDidAddCurrencyPair: (() -> Void)? { get set }
    var currencies: [Currency] { get }
}

protocol CurrencyTableViewProtocol: AnyObject {
    var inputs: CurrencyTableViewInputs { get }
    var outputs: CurrencyTableViewOutputs { get set }
}

final class CurrencyTableViewModel: CurrencyTableViewInputs, CurrencyTableViewOutputs, CurrencyTableViewProtocol {

    var inputs: CurrencyTableViewInputs { self }
    var outputs: CurrencyTableViewOutputs {
        get { self }
        set { }
    }

    private let viewContext: NSManagedObjectContext
    private var selectedCurrencies: [Currency] = [] {
        didSet {
            guard selectedCurrencies.count == Constants.maxSelectedCurrencies else { return }
            addCurrencyPairIfNeeded()
            selectedCurrencies.removeAll()
        }
    }

    private var currencyPair: CurrencyPair? {
        didSet {
            userDidAddCurrencyPair?()
        }
    }

    init(with currencies: [Currency], viewContext: NSManagedObjectContext = AppDelegate.shared.persistentContainer.viewContext) {
        self.viewContext = viewContext
        self.currencies = currencies
    }

    func userDidSelectCurrency(at index: Int) {
        let selectedCurrency = currencies[index]
        if !selectedCurrencies.contains(where: { $0 == selectedCurrency }) {
            selectedCurrencies.append(selectedCurrency)
        }
    }

    // Outputs
    var userDidAddCurrencyPair: (() -> Void)?
    let currencies: [Currency]
}

extension CurrencyTableViewModel {

    private func addCurrencyPairIfNeeded() {
        let fetcRequest = CurrencyPair.fetchRequest(fromCurrencyCode: selectedCurrencies[0].code, toCurrencyCode: selectedCurrencies[1].code)

        do {
            if let currencyPair = try viewContext.fetch(fetcRequest).first {
                self.currencyPair = currencyPair
                return
            }
        } catch _ { }

        currencyPair = CurrencyPair.make(with: viewContext,
                                         fromCurrencyCode: selectedCurrencies[0].code,
                                         toCurrencyCode: selectedCurrencies[1].code,
                                         fromCurrencyName: selectedCurrencies[0].name,
                                         toCurrencyName: selectedCurrencies[1].name)

        viewContext.saveContext()
    }
}
