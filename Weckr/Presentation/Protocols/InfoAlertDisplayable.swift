//
//  InfoAlertDisplayable.swift
//  Weckr
//
//  Created by Tim Mewe on 26.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol InfoAlertDisplayable {
    func showInfoAlert(info: AlertInfo)
}

extension InfoAlertDisplayable where Self: UIViewController {
    func showInfoAlert(info: AlertInfo) {
        let alert = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Main.Edit.clever, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
