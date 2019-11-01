//
//  CellIdentifier.swift
//  Revolut
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
         String(describing: self)
    }
}
