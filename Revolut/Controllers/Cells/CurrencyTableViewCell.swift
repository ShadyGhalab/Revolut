//
//  CurrencyTableViewCell.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isUserInteractionEnabled = true
    }
}
