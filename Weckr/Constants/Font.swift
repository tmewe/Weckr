//
//  Font.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

struct Font {
    struct Size {
        struct Walkthorugh {
            static let title: CGFloat = 34
            static let subTitle: CGFloat = 34
            static let nextButton: CGFloat = 20
            static let prevButton: CGFloat = 20
        }
        
        struct TableHeader {
            static let date: CGFloat = 13
            static let title: CGFloat = 34
        }
        
        struct TileCell {
            static let title: CGFloat = 15
            static let time: CGFloat = 15
            static let info: CGFloat = 28
            static let subTitle: CGFloat = 15
            static let timespan: CGFloat = 24
        }
        
        struct Overlay {
            static let errorTitle: CGFloat = 48
            static let errorMessage: CGFloat = 24
        }
    }
}
