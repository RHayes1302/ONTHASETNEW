//
//  Item.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
