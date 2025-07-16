//
//  Pairing.swift
//  Expedite
//
//  Created by Nizar Elfennani on 12/7/2025.
//

import SwiftUI
import CertificateSigningRequest
import Network

struct Pairing: View {
    private let device: Device
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    private var viewModel: PairingViewModel {
         PairingViewModel(device: device, onSave: {device in self.onSave(device)})
    }
    
    init(device: Device) {
        self.device = device
    }
    
    var body: some View {
        VStack{
            Text("Pairing with \(device.name)...")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.start()
            }
    }
    
    func onSave(_ pairedDevice:PairedDevice){
        modelContext.insert(pairedDevice)
        print("Paired Device: \(pairedDevice)")
        try? modelContext.save()
        dismiss()
    }
}
