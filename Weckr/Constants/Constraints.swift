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
    
    struct Buttons {
        struct RoundedButton {
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
    
    struct Walkthrough {
        struct Title {
            static let horizontalSides: CGFloat = 50
            static let title1Top: CGFloat = 80
            static let title2Bottom: CGFloat = 40
            static let title2Offset: CGFloat = 200
            static let width: CGFloat = 272
        }
    }
    
    struct Main {
        struct Header {
            static let top: CGFloat = 15
            static let bottom: CGFloat = 15
            static let left: CGFloat = 20
            static let spacing: CGFloat = 3
        }
        
        struct Tile {
            static let heightWithSpacing: CGFloat = 120
            static let defaultHeight: CGFloat = 100
            static let top: CGFloat = 10
            static let bottom: CGFloat = 10
            static let left: CGFloat = 20
            static let right: CGFloat = 20
        }
        
        struct Text {
            static let top: CGFloat = 20
            static let bottom: CGFloat = 20
            static let left: CGFloat = 20
            static let right: CGFloat = 20
            static let largeSpacing: CGFloat = 10
            static let smallSpacing: CGFloat = 4
        }
        
        struct Alarm {
            static let top: CGFloat = 50
            static let spacing: CGFloat = 40
            static let bottom: CGFloat = 20
        }
        
        struct Edit {
            static let titleTop: CGFloat = 50
            static let titleLeft: CGFloat = 50
            static let titleWidth: CGFloat = 272
            static let buttonBottom: CGFloat = 50
            static let switchOffset: CGFloat = 50
            static let switchRight: CGFloat = 50
            static let spacing: CGFloat = 20
        }
    }
}
