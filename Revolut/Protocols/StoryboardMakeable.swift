//
//  StoryboardMakeable.swift
//  Revolut
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

import UIKit

public protocol StoryboardMakeable: class {

    associatedtype StoryboardMakeableType
    static var storyboardName: String { get }
    static func make() -> StoryboardMakeableType
}

public extension StoryboardMakeable where Self: UIViewController {

    static func make() -> StoryboardMakeableType {
        let viewControllerId = String(describing: self)

        return make(with: viewControllerId)
    }

    static func make(with viewControllerId: String) -> StoryboardMakeableType {
        let storyboard = UIStoryboard(name: storyboardName,
                                      bundle: Bundle(for: self))

        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? StoryboardMakeableType else {
            fatalError("Did not find \(viewControllerId) in \(storyboardName)!")
        }

        return viewController
    }
}
