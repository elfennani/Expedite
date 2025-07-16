//
//  Data.swift
//  Expedite
//
//  Created by Nizar Elfennani on 15/7/2025.
//

struct DataRequest: Encodable, Decodable {
    let type: String
    var psk: String? = nil
}
