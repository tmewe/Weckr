//
//  CalendarEditSection.swift
//  Weckr
//
//  Created by Tim Lehmann on 18.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxDataSources

struct CalendarEditSection {
    var header: String
    var items: [CalendarEditSectionItem]
}

extension CalendarEditSection: SectionModelType {
    typealias Item = CalendarEditSectionItem
    typealias Identity = String
    
    var identity: String {
        return "CalendarSection"
    }
    
    init(original: CalendarEditSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct EventEditWrapper {
    var event: CalendarEntry
    var description: String
    var selected: Bool
    var gradient: Gradient {
        if selected {
            return Gradient(left: UIColor.eventCellLeft.cgColor,
                            right: UIColor.eventCellRight.cgColor)
        }
        return Gradient(left: UIColor.eventEditCellLeft.cgColor,
                        right: UIColor.eventEditCellRight.cgColor)
    }
}

enum CalendarEditSectionItem {
    case title(text: String, coloredPart: String)
    case calendarItem(event: EventEditWrapper)
}
