//
//  PairingViewModel.swift
//  Expedite
//
//  Created by Nizar Elfennani on 16/7/2025.
//

import SwiftUI
import Foundation
import SwiftData
import Network

enum PairingError: Error {
    case sendingFailed(raison: Error)
}


@MainActor
final class PairingViewModel : ObservableObject {
    private let device: Device
    private let onSave: (PairedDevice) -> Void
    private var connection: NWConnection?

    init(device: Device, onSave: @escaping (PairedDevice) -> Void) {
        self.device = device
        self.onSave = onSave
    }
    
    func start() {
        connection = NWConnection(to: device.host, using: .tcp)
        
        connection?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Connection ready!")
                Task{ @MainActor in
                    try self.pair()
                }
            case .failed(let error):
                print("Connection failed: \(error)")
            default:
                break
            }
        }
        
        connection?.start(queue: .main)
        awaitResponse()
    }
    
    private func awaitResponse() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536) {
            data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                var response = String(data: data, encoding: .utf8)!
                
                if(response.hasSuffix("\n")){
                    response = response.split(separator: "\n").dropLast().joined(separator: "\n")
                }
                
                Task{ @MainActor in
                    self.receive(message: response)
                }
                print("Received: \(response)")
            }
            
            if isComplete {
                print("Connection is complete and closed by peer.")
            } else if let error = error {
                print("An error occurred: \(error)")
            } else {
                Task{ @MainActor in
                    self.awaitResponse()
                }
            }
        }
    }
    
    private func pair() throws {
        let message = try! JSONEncoder().encode(DataRequest(type: "PSK_REQUEST"))
        if let string = String(data: message, encoding: .utf8) {
            print("Sending: \(string)")
            try sendMessage(string + "\n")
        }
    }
    
    private func sendMessage(_ message: String) throws {
        let data = message.data(using: .utf8)
        var error: Error?
        connection?.send(content: data, completion: .contentProcessed { err in
            if let err = err {
                error = PairingError.sendingFailed(raison: err)
            }
        })
        
        if let error = error {
            throw error
        }
    }
    
    private func sendEncodable<T: Encodable>(_ value: T) throws {
        let data = try JSONEncoder().encode(value)
        if let string = String(data: data, encoding: .utf8) {
            print("Sending: \(string)")
            try sendMessage(string + "\n")
        }
    }
    
    private func receive(message: String){
        do {
            let decoded = try JSONDecoder().decode(DataRequest.self, from:message.data(using: .utf8)! )
            
            if(decoded.type == "PSK_RESPONSE"){
                guard let psk = decoded.psk else {
                    print("No PSK provided!")
                    return
                }
                
                onSave(
                    PairedDevice(
                        id: UUID().uuidString,
                        name: self.device.name,
                        host: self.device.host.debugDescription,
                        psk: psk,
                        createdAt: Date()
                    )
                )
                try! self.sendEncodable(DataRequest(type: "ACK"))
            }
        } catch {
            print(error)
        }
    }
}
