//
//  Spacing.swift
//  Weckr
//
//  Created by Tim Lehmann on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

struct Constraints {
    
    struct Walkthrough {
        struct Title {
            static let horizontalSides: CGFloat = 50
            static let title1Top: CGFloat = 80
            static let title2Bottom: CGFloat = 40
            static let title2Offset: CGFloat = 200
            static let width: CGFloat = 272
        }
    
        struct NextButton {
            static let width: CGFloat = 200
            static let height: CGFloat = 60
            static let bottomOffset: CGFloat = 15
        }
        
        struct PreviousButton {
            static let width: CGFloat = 200
            static let height: CGFloat = 60
            static let bottomOffset: CGFloat = 15
        }
    }
    
    struct Main {
        struct Insets {
            static let medium: CGFloat = 13
            static let regular: CGFloat = 22
            static let large: CGFloat = 30
        }
    }
}
