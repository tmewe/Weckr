//
//  String+Extenstions.swift
//  Weckr
//
//  Created by Tim Lehmann on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
    
}
