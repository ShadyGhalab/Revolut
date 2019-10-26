//
//  CurrencyPairViewModelTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class CurrencyPairViewModelTests: XCTestCase {
   
    var currencyPair: CurrencyPair!
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        viewContext = AppDelegate.shared.persistentContainer.viewContext
        currencyPair = CurrencyPair.make(with: viewContext,
                                              fromCurrencyCode: "CZK",
                                              toCurrencyCode: "USD",
                                              fromCurrencyName: "Czech Koruna ",
                                              toCurrencyName: "United States Dollar")
        
        viewContext.saveContext()
        
    }
    
    func testWillDeleteCurrencyPairCell_whenTheUserDeletesCurrencyPair() {
        let viewModel: CurrencyPairViewProtocol = CurrencyPairViewModel()
        _ = viewModel.outputs.fetchedResultController
        
        var willDeleteCurrencyPairCellCalled = false
        viewModel.outputs.willDeleteCurrencyPairCell = { indexPath in
            willDeleteCurrencyPairCellCalled = true
        }
        
        viewContext.delete(currencyPair)
        viewContext.saveContext()
        
        XCTAssertTrue(willDeleteCurrencyPairCellCalled)
    }
}
