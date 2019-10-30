//
//  NSManagedObjectContext+Save.swift
//  Revolut
//
//  Created by Shady Mustafa on 26.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveContext () {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
