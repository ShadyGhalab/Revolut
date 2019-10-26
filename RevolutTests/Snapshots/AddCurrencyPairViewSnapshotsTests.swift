//
//  AddCurrencyPairViewSnapshotsTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import Revolut

class AddCurrencyPairViewSnapshotsTests: FBSnapshotTestCase {
   
    private var viewController: AddCurrencyPairViewController!
    private var window: UIWindow = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    override func setUp() {
        super.setUp()

        fileNameOptions = [.device, .OS, .screenSize]
        
        setupView()
    }
    
    func setupView() {
        viewController = AddCurrencyPairViewController.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([viewController], animated: false)
        window.addSubview(navigationController.view)
        window.makeKeyAndVisible()
    }
    
    func testAddCurrencyPairViewController() {
        FBSnapshotVerifyView(viewController.view)
    }
}
