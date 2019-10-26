//
//  CurrencyPairViewController.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

private enum Constants {
    static let rowHeight: CGFloat = 80.0
}

final class CurrencyPairViewController: UIViewController, StoryboardMakeable {

    static var storyboardName: String = "Main"
    typealias StoryboardMakeableType = CurrencyPairViewController

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource: CurrencyPairTableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = self
        }
    }

    var viewModel: CurrencyPairViewProtocol! {
        didSet {
            guard dataSource == nil else { return }
            dataSource = CurrencyPairTableViewDataSource(fetchedResultController: viewModel.outputs.fetchedResultController)
            bindViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CurrencyPairTableViewCell.identifier, bundle: nil),
                                  forCellReuseIdentifier: CurrencyPairTableViewCell.identifier)
    }

    private func bindViewModel() {
        viewModel.outputs.didDeleteCurrencyPair = { [unowned self] indexPath in
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction private func addCurrencyPairsButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CurrencyPairViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
