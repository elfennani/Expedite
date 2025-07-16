//
//  PairedDevice.swift
//  Expedite
//
//  Created by Nizar Elfennani on 15/7/2025.
//

import SwiftData
import Foundation

@Model
class PairedDevice {
    var id: String
    var name: String
    var host: String
    var psk: String
    var createdAt: Date
    
    init(id: String, name: String, host: String, psk: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.host = host
        self.psk = psk
        self.createdAt = createdAt
    }
}
