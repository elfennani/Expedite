//
//  DeviceCard.swift
//  Expedite
//
//  Created by Nizar Elfennani on 12/7/2025.
//
import SwiftUI


struct DeviceCard: View {
    let device: Device
    let isSelected: Bool
    let onSelect: (() -> Void)?
    @Environment(\.colorScheme) var colorScheme
    
    init(device: Device, isSelected: Bool = false, onSelect: (() -> Void)? = nil) {
        self.device = device
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(device.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.cardForeground)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(device.model)
                    .font(.caption)
                    .foregroundColor(.cardSecondaryForeground)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            
            if(isSelected){
                Text("Selected")
                    .font(.caption)
                    .foregroundColor(.accent)
            }
            else {
                Button(action: {
                    onSelect?()
                }){
                    Label("Select", systemImage: "checkmark").padding(6)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.card)
        .cornerRadius(12)
        .shadow(radius: colorScheme == .dark ? 0 : 4)
        .if(colorScheme == .dark || isSelected, transform: {view in
            view.overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .accent : .border, lineWidth: isSelected ? 2 : 1)
            }
        })
        .transition(
            .asymmetric(
                insertion: .offset(x: -30).combined(with: .opacity),
                removal: .offset(x: 30).combined(with: .opacity)
            ).animation(.easeOut(duration: 0.20))
        )
    }
}

#Preview {
    DeviceCard(device: Device(name: "Elfennani's Galaxy A54", model: "SM-A545F"))
}
