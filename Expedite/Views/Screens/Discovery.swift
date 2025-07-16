//
//  Discovery.swift
//  Expedite
//
//  Created by Nizar Elfennani on 12/7/2025.
//
import SwiftUI
import SwiftData
import AsyncDNSResolver
import Foundation
import Network

struct Discovery: View {
    @State var devices: [Device] = []
    @State var selectedDevice: Device?
    @State var deviceToPair: Device? = nil
    
    var body: some View {
        HStack{
            VStack(spacing: 24){
                Image("AppIconImage")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .shadow(radius: 10)
                
                VStack(spacing: 8){
                    Text("Your Phone & Mac, \nBetter Together")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(.light)
                        .fontWidth(.expanded)
                        .frame(maxWidth: .infinity)
                        
                    Text("To get started, install the companion app on your Android phone. Connect once, and enjoy notifications, file sharing, and more — right from your Mac.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .lineSpacing(9)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }.frame(maxWidth: 400)
                
                Button(action: {}){
                    Label("Copy Link", systemImage: "link")
                }.buttonStyle(PrimaryButtonStyle())
                
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            Divider()
                .padding(.vertical, 40)
            VStack(alignment: .leading){
                Text("Nearby devices")
                    .font(.title)
                    
                VStack (alignment: devices.isEmpty ? .center : .leading, spacing: 8){
                    if(devices.isEmpty){
                        Text("No devices found")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(devices){ device in
                            DeviceCard(device: device, isSelected: device.id == selectedDevice?.id){
                                selectedDevice = device
                            }
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .animation(.easeInOut(duration: 0.3), value: devices)
                
                Button(action: {
                    deviceToPair = selectedDevice
                }){
                    Label("Next", systemImage: "arrow.forward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!devices.contains(where: {$0.id == selectedDevice?.id}))
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 16)
            .frame(width: 380)
            .clipped()
        }
        .frame(minWidth: 850, minHeight: 550)
        .onAppear {
            scanNearbyDevices()
        }.sheet(isPresented: Binding(
            get: { deviceToPair != nil },
            set: { isPresented in
                if !isPresented {
                    deviceToPair = nil
                }
            }
        )){
            if(selectedDevice != nil){
                Pairing(device: selectedDevice!)
            }
        }
    }
    
    private func scanNearbyDevices(){
        let browser = NWBrowser(for: .bonjourWithTXTRecord(type: "_expedite._tcp", domain: nil), using: .tcp)
        browser.start(queue: .main)
        
        browser.browseResultsChangedHandler = { results, _ in
            withAnimation{
                devices = results.compactMap {
                    guard case let .bonjour(records) = $0.metadata else {
                        return nil;
                    }
                    
                    if let name = records["username"], let model = records["model"] {
                        print($0)
                        return Device(name: name, model: model, host: $0.endpoint)
                    }
                    
                    return nil
                }
            }
        }
    }
}
