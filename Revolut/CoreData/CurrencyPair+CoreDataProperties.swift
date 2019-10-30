//
//  CurrencyPair+CoreDataProperties.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//
//

import Foundation
import CoreData

extension CurrencyPair {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CurrencyPair> {
        return NSFetchRequest<CurrencyPair>(entityName: "CurrencyPair")
    }

    @nonobjc class func fetchRequest(fromCurrencyCode: String, toCurrencyCode: String) -> NSFetchRequest<CurrencyPair> {
        let fetcRequest: NSFetchRequest = CurrencyPair.fetchRequest()
        let predicate = NSPredicate(format: "fromCurrencyCode == %@ && toCurrencyCode == %@", fromCurrencyCode, toCurrencyCode)
        fetcRequest.predicate = predicate

        return fetcRequest
    }

    @NSManaged var fromCurrencyCode: String
    @NSManaged var toCurrencyCode: String
    @NSManaged var fromCurrencyName: String
    @NSManaged var toCurrencyName: String
    @NSManaged var createdAt: Date

    static func make(with viewContext: NSManagedObjectContext,
                     fromCurrencyCode: String,
                     toCurrencyCode: String,
                     fromCurrencyName: String,
                     toCurrencyName: String,
                     createdAt: Date = Date()) -> CurrencyPair {

        let currencyPair = CurrencyPair(context: viewContext)
        currencyPair.fromCurrencyCode = fromCurrencyCode
        currencyPair.toCurrencyCode = toCurrencyCode
        currencyPair.fromCurrencyName = fromCurrencyName
        currencyPair.toCurrencyName = toCurrencyName
        currencyPair.createdAt = createdAt

        return currencyPair
    }
}
