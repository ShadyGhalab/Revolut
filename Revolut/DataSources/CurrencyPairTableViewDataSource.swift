//
//  CurrencyPairTableViewDataSource.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit
import CoreData

final class CurrencyPairTableViewDataSource: NSObject, UITableViewDataSource {

    private let fetchedResultController: NSFetchedResultsController<CurrencyPair>

    init(fetchedResultController: NSFetchedResultsController<CurrencyPair>) {
        self.fetchedResultController = fetchedResultController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyPairTableViewCell.identifier, for: indexPath) as? CurrencyPairTableViewCell
        if let currencyPair = currencyPair(at: indexPath) {
            cell?.viewModel = CurrencyPairCellViewModel(currencyPair: currencyPair)
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let currencyPair = currencyPair(at: indexPath) else { return }

        fetchedResultController.managedObjectContext.delete(currencyPair)
        fetchedResultController.managedObjectContext.saveContext()
    }
}

extension CurrencyPairTableViewDataSource {
    private func currencyPair(at indexPath: IndexPath) -> CurrencyPair? {
        return fetchedResultController.fetchedObjects?[indexPath.item]
    }
}
