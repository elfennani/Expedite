//
//  ContentView.swift
//  Expedite
//
//  Created by Nizar Elfennani on 10/7/2025.
//

import SwiftUI
import SwiftData
import AsyncDNSResolver
import Foundation
import Network

struct ContentView: View {
    @Query var pairedDevice: [PairedDevice]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack{
            if(pairedDevice.count != 0){
                VStack{
                    Text("Welcome \(pairedDevice[0].name)!")
                    Button(action: {
                        modelContext.delete(pairedDevice[0])
                    }){
                        Label("Unpair", systemImage: "xmark")
                    }.buttonStyle(PrimaryButtonStyle())
                }
            }else{
                Discovery()
            }
        }
    }
}

#Preview {
    ContentView()
}
