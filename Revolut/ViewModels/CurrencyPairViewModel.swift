//
//  CurrencyPairViewModel.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import CoreData

protocol CurrencyPairViewInputs { }

protocol CurrencyPairViewOutputs {
    var fetchedResultController: NSFetchedResultsController<CurrencyPair> { get }
    var didDeleteCurrencyPair: ((IndexPath) -> Void)? { get set }
    var headerLabelLocalizedText: String { get }
}

protocol CurrencyPairViewProtocol: AnyObject {
    var inputs: CurrencyPairViewInputs { get }
    var outputs: CurrencyPairViewOutputs { get set }
}

final class CurrencyPairViewModel: NSObject, CurrencyPairViewInputs, CurrencyPairViewOutputs, CurrencyPairViewProtocol {

    var inputs: CurrencyPairViewInputs { self }
    var outputs: CurrencyPairViewOutputs {
        get { self }
        set { }
    }

    private var _fetchedResultsController: NSFetchedResultsController<CurrencyPair>? // swiftlint:disable:this identifier_name
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = AppDelegate.shared.persistentContainer.viewContext) {
        self.viewContext = viewContext
        self.headerLabelLocalizedText = "revolut.addCurrencyPair.title".localized
    }

    // Outputs
    var didDeleteCurrencyPair: ( (IndexPath) -> Void)?
    let headerLabelLocalizedText: String
}

extension CurrencyPairViewModel: NSFetchedResultsControllerDelegate {

    var fetchedResultController: NSFetchedResultsController<CurrencyPair> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController! // swiftlint:disable:this force_unwrapping
        }

        let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
         fetchedResultsController .delegate = self
        _fetchedResultsController = fetchedResultsController

        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror)")
        }
        return _fetchedResultsController! // swiftlint:disable:this force_unwrapping
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath { didDeleteCurrencyPair?(indexPath) }
        default:
            break
        }
    }
}
