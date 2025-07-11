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
import dnssd
import CFNetwork
import CAsyncDNSResolver
import sys_select
import Network

struct ContentView: View {
    var body: some View {
        Text("Hello World!")
            .onAppear {
                scanNearbyDevices()
            }
    }
    
    private func scanNearbyDevices(){
        let browser = NWBrowser(for: .bonjourWithTXTRecord(type: "_expedite._tcp", domain: "local"), using: .tcp)
        browser.start(queue: .main)
        
        browser.browseResultsChangedHandler = { results, _ in
            print(results)
        }
    }
}

#Preview {
    ContentView()
}
