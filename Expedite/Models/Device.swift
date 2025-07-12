//
//  Device.swift
//  Expedite
//
//  Created by Nizar Elfennani on 11/7/2025.
//

import Foundation

struct Device: Identifiable, Equatable{
    let id: UUID = UUID()
    let name: String
    let model: String
}
