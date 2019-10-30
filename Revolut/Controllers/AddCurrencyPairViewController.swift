//
//  AddCurrencyPairViewController.swift
//  Revolut
//
//  Created by Shady Mustafa on 22.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

final class AddCurrencyPairViewController: UIViewController, StoryboardMakeable {

    static var storyboardName: String = "Main"
    typealias StoryboardMakeableType = AddCurrencyPairViewController

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        titleLabel.text = viewModel.outputs.titleLabelLocalizedText
        descriptionLabel.text = viewModel.outputs.descriptionLabelLocalizedText
    }

    @IBAction private func addCurrencyPairsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowCurrencyTableViewController", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let viewController = segue.destination as? CurrencyTableViewController else { return }

        let currencies = viewModel.outputs.currencies
        viewController.viewModel = CurrencyTableViewModel(with: currencies)
    }
}
