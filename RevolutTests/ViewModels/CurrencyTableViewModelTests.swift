//
//  CurrencyTableViewModelTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class CurrencyTableViewModelTests: XCTestCase {
    
    func testCurrenciesData_whenTwoCurrenciesAreAvailable() {
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        XCTAssertEqual(viewModel.outputs.currencies.first?.name, "Pound sterling")
        XCTAssertEqual(viewModel.outputs.currencies.first?.imageName, "UK")
        XCTAssertEqual(viewModel.outputs.currencies.first?.code, "GBP")
        
        XCTAssertEqual(viewModel.outputs.currencies.last?.name, "United States Dollar")
        XCTAssertEqual(viewModel.outputs.currencies.last?.imageName, "US")
        XCTAssertEqual(viewModel.outputs.currencies.last?.code, "USD")
    }
    
    func testCurrenciesCount_whenTwoCurrenciesAreAvailable() {
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        XCTAssertTrue(viewModel.outputs.currencies.count == 2)
    }
    
    func testCreatingCurrencyPair_whenUserSelectsTwoCurrency() {
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        var userDidAddCurrencyPairCalled = false
        viewModel.outputs.userDidAddCurrencyPair = {
            userDidAddCurrencyPairCalled = true
        }
        
        viewModel.inputs.userDidSelectCurrency(at: 0)
        viewModel.inputs.userDidSelectCurrency(at: 1)
        
        XCTAssertTrue(userDidAddCurrencyPairCalled)
    }
    
    func testCreatingCurrencyPair_whenUserSelectsOneCurrency() {
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        var userDidAddCurrencyPairCalled = false
        viewModel.outputs.userDidAddCurrencyPair = {
            userDidAddCurrencyPairCalled = true
        }
        
        viewModel.inputs.userDidSelectCurrency(at: 0)
        
        XCTAssertFalse(userDidAddCurrencyPairCalled)
    }
    
    func testCreatingCurrencyPair_whenBothCurrenciesAreTheSame() {
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        var userDidAddCurrencyPairCalled = false
        viewModel.outputs.userDidAddCurrencyPair = {
            userDidAddCurrencyPairCalled = true
        }
        
        viewModel.inputs.userDidSelectCurrency(at: 0)
        viewModel.inputs.userDidSelectCurrency(at: 0)
        
        XCTAssertFalse(userDidAddCurrencyPairCalled)
    }
    
    func testAddingCurrencyPairIfNeeded_whenTheCurrencyPairAlreadyInCoreData() {
        let viewContext: NSManagedObjectContext = AppDelegate.shared.persistentContainer.viewContext
         _ = CurrencyPair.make(with: viewContext,
                              fromCurrencyCode: "GBP",
                              toCurrencyCode: "USD",
                              fromCurrencyName: "Pound sterling",
                              toCurrencyName: "United States Dollar")
        
        viewContext.saveContext()
        
        let fromCurrency = Currency.make()
        let toCyrrency = Currency.make(imageName: "US", code: "USD", name: "United States Dollar")
        
        let viewModel: CurrencyTableViewProtocol = CurrencyTableViewModel(with: [fromCurrency, toCyrrency])
        
        var userDidAddCurrencyPairCalled = false
        viewModel.outputs.userDidAddCurrencyPair = {
            userDidAddCurrencyPairCalled = true
        }
        
        viewModel.inputs.userDidSelectCurrency(at: 0)
        viewModel.inputs.userDidSelectCurrency(at: 1)
        
        let fetcRequest: NSFetchRequest = CurrencyPair.fetchRequest()
        let predicate = NSPredicate(format: "fromCurrencyCode == %@ && toCurrencyCode == %@", "GBP", "USD")
        fetcRequest.predicate = predicate
        
        XCTAssertTrue(try viewContext.fetch(fetcRequest).count == 1)
        XCTAssertTrue(userDidAddCurrencyPairCalled)
    }
}

extension Currency {
    static func make(imageName: String = "UK", code: String = "GBP", name: String = "Pound sterling") -> Currency {
        return Currency(imageName: imageName, code: code, name: name)
    }
}
