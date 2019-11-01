//
//  UIView+Nib.swift
//  Revolut
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

protocol ViewLoading {}

extension UIView: ViewLoading {}

extension ViewLoading where Self: UIView {
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        let finalNibName = nibName ?? className
        let nib = UINib(nibName: finalNibName, bundle: Bundle(for: Self.self))

        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Error! Unexpected type loaded from \(finalNibName) nib.")
        }

        return loadedView
    }

    private static var className: String {
        String(describing: self)
    }
}
