//
//  EditableCell.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import Action

protocol EditableCell {}

extension EditableCell where Self: UITableViewCell {
    func showEditIcon() {
        let editButton = UIButton(type: .custom)
        editButton.setImage(UIImage(named: "edit_icon"), for: .normal)
        addSubview(editButton)
    }
}
