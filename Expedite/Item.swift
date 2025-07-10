//
//  Item.swift
//  Expedite
//
//  Created by Nizar Elfennani on 10/7/2025.
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
