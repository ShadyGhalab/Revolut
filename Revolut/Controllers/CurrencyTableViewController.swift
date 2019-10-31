//
//  CurrencyTableViewController.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

private enum Constants {
    static let animationDuration: TimeInterval = 0.5
}

final class CurrencyTableViewController: UITableViewController, StoryboardMakeable {
    
    static var storyboardName: String = "Main"
    typealias StoryboardMakeableType = CurrencyTableViewController
    
    private var dataSource: CurrencyTableViewDataSource? {
        didSet {
            tableView.delegate = self
            tableView.dataSource = dataSource
        }
    }
    
    var viewModel: CurrencyTableViewProtocol! {
        didSet {
            guard dataSource == nil else { return }
            dataSource = CurrencyTableViewDataSource(currencies: viewModel.outputs.currencies)
            bindViewModel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        
        super.viewWillAppear(animated)
    }
    
    private func bindViewModel() {
        viewModel.outputs.userDidAddCurrencyPair = { [unowned self] in
            self.performSegue(withIdentifier: "ShowCurrencyPairsViewController", sender: nil)
        }
        
        viewModel.outputs.tableViewNeedsAnimation = { [unowned self] in
            self.tableView.animate()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.userDidSelectCurrency(at: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let viewController = segue.destination as? CurrencyPairViewController else { return }
        
        viewController.loadViewIfNeeded()
        viewController.viewModel = CurrencyPairViewModel()
    }
}

private extension UITableView {
    func animate(with animationOptions: AnimationOptions = .curveEaseInOut,
                 duration: TimeInterval = Constants.animationDuration,
                 parentViewFrame: CGRect = UIScreen.main.bounds) {
        
        var frame: CGRect = self.frame
        frame.origin.x = parentViewFrame.size.width
        self.frame = frame
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            var frame: CGRect = frame
            frame.origin.x = 0
            self.frame = frame
        })
    }
}
