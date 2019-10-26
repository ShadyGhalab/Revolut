//
//  CurrencyTableViewDataSource.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

final class CurrencyTableViewDataSource: NSObject, UITableViewDataSource {

    private let currencies: [Currency]

    init(currencies: [Currency]) {
        self.currencies = currencies
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell
        let currency = currencies[indexPath.row]

        cell?.currencyImageView.image = UIImage(named: currency.imageName)
        cell?.currencyCodeLabel.text = currency.code
        cell?.currencyNameLabel.text = currency.name

        return cell ?? UITableViewCell()
    }
}
