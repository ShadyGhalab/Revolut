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
    var willDeleteCurrencyPairCell: ((IndexPath) -> Void)? { get set }
}

protocol CurrencyPairViewProtocol: AnyObject {
    var inputs: CurrencyPairViewInputs { get }
    var outputs: CurrencyPairViewOutputs { get set }
}

final class CurrencyPairViewModel: NSObject, CurrencyPairViewInputs, CurrencyPairViewOutputs, CurrencyPairViewProtocol {

    var inputs: CurrencyPairViewInputs { return self }
    var outputs: CurrencyPairViewOutputs { set { } get { return self } }

    private var _fetchedResultsController: NSFetchedResultsController<CurrencyPair>? // swiftlint:disable:this identifier_name
    private let viewContext: NSManagedObjectContext
    var willDeleteCurrencyPairCell: ( (IndexPath) -> Void)?

    init(viewContext: NSManagedObjectContext = AppDelegate.shared.persistentContainer.viewContext) {
        self.viewContext = viewContext
    }
}

extension CurrencyPairViewModel: NSFetchedResultsControllerDelegate {

    var fetchedResultController: NSFetchedResultsController<CurrencyPair> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController! // swiftlint:disable:this force_unwrapping
        }

        let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()
        let managedObjectContext = viewContext

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: managedObjectContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        resultsController.delegate = self
        _fetchedResultsController = resultsController

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
            if let indexPath = indexPath {
                willDeleteCurrencyPairCell?(indexPath)
            }
        default:
            break
        }
    }
}
