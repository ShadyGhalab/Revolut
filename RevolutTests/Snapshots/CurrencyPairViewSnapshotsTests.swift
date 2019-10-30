//
//  CurrencyPairViewSnapshotsTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
import CoreData
@testable import Revolut

class CurrencyPairViewSnapshotsTests: FBSnapshotTestCase {
    
    private var viewController: CurrencyPairViewController!
    private var viewModel: CurrencyPairViewProtocol!
    private var currencyPair: CurrencyPair!
    private var viewContext: NSManagedObjectContext!
    
    private var window: UIWindow = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    override func setUp() {
        super.setUp()

        fileNameOptions = [.device, .OS, .screenSize]

        viewContext = AppDelegate.shared.persistentContainer.viewContext
        currencyPair = CurrencyPair.make(with: viewContext,
                                         fromCurrencyCode: "NOK",
                                         toCurrencyCode: "USD",
                                         fromCurrencyName: "Norwegian krone",
                                         toCurrencyName: "United States Dollar")
        
        viewContext.saveContext()
        
        setupView()
    }
    
    func setupView() {
        viewController = CurrencyPairViewController.make()
        viewController.loadViewIfNeeded()
        
        viewModel = CurrencyPairViewModel()
        _ = viewModel.outputs.fetchedResultController
        
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window.addSubview(navigationController.view)
        window.makeKeyAndVisible()
    }
    
    func testCurrencyPairViewController() {
        FBSnapshotVerifyView(viewController.view)
    }
    
    override func tearDown() {
        viewContext.delete(currencyPair)
        viewContext.saveContext()
        
        super.tearDown()
    }
}
