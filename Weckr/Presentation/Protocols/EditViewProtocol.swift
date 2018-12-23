//
//  EditViewProtocol.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol EditViewProtocol {
    var topLabel: UILabel { get set }
    var bottomLabel: UILabel { get set }
    var button: RoundedButton { get set }
}
