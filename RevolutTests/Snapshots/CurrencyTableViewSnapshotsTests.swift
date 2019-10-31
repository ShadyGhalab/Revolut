//
//  CurrencyTableViewSnapshotsTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Revolut

class CurrencyTableViewSnapshotsTests: FBSnapshotTestCase {
    
    private var viewController: CurrencyTableViewController!
    private var viewModel: CurrencyTableViewProtocol!
    private var window: UIWindow = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    override func setUp() {
        super.setUp()

        fileNameOptions = [.device, .OS, .screenSize]

        setupView()
    }
    
    func setupView() {
        viewController = CurrencyTableViewController.make()
        viewModel = CurrencyTableViewModelMock()
        
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window.addSubview(navigationController.view)
        window.makeKeyAndVisible()
    }
    
    func testCurrencyTableViewController() {
        FBSnapshotVerifyView(viewController.view)
    }
}

private final class CurrencyTableViewModelMock: CurrencyTableViewInputs, CurrencyTableViewOutputs, CurrencyTableViewProtocol {
    var inputs: CurrencyTableViewInputs {  self }
    var outputs: CurrencyTableViewOutputs {
        get {  self }
        set { }
    }
    
    func userDidSelectCurrency(at index: Int) { }
    
    let canAnimateTableView: Bool = true
    var userDidAddCurrencyPair: (() -> Void)?
    var currencies: [Currency] = [Currency.make(), Currency.make(imageName: "US", code: "USD", name: "United States Dollar")]
}
