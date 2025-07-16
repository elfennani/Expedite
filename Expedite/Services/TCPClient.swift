//
//  TCPClient.swift
//  Expedite
//
//  Created by Nizar Elfennani on 14/7/2025.
//

import Network
import Foundation

class TCPClient {
    var onMessageReceived: ((Data) -> Void)?
    
    private var connection: NWConnection?
    private let host: NWEndpoint
    private let port: NWEndpoint.Port

    init(host: NWEndpoint, port: UInt16) {
        self.host = host
        self.port = NWEndpoint.Port(rawValue: port)!
    }

    func start() {
        connection = NWConnection(to: host, using: .tcp)

        connection?.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("✅ Connected to \(self.host):\(self.port)")
//                self.send(message: "Hello server!")
                self.receive()
            case .failed(let error):
                print("❌ Connection failed: \(error)")
            default:
                break
            }
        }

        connection?.start(queue: .global())
    }
    
    func registerReceiver(_ receiver: @escaping (Data) -> Void) {
        self.onMessageReceived = receiver
    }

    func send(message: String) {
        let data = message.data(using: .utf8)!
        connection?.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("❌ Send error: \(error)")
            } else {
                print("📤 Sent: \(message)")
            }
        }))
        
    }
    
    func sendEncodable(_ data: Encodable) throws {
        let jsonData = try JSONEncoder().encode(data)
        let message = String(decoding: jsonData, as: UTF8.self)
        send(message: message)
    }

    func receive() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                let response = String(decoding: data, as: UTF8.self)
                self.onMessageReceived?(data)
                print("📥 Received: \(response)")
            }
            if isComplete {
                print("✅ Connection closed by server")
            } else if let error = error {
                print("❌ Receive error: \(error)")
            } else {
                self.receive()
            }
        }
    }

    func stop() {
        connection?.cancel()
        print("⏹️ Connection stopped")
    }
}
