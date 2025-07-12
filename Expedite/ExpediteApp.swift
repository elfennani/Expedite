//
//  ExpediteApp.swift
//  Expedite
//
//  Created by Nizar Elfennani on 10/7/2025.
//

import SwiftUI
import SwiftData

extension View {
    public static func semiOpaqueWindow() -> some View {
        VisualEffect().ignoresSafeArea()
    }
}

struct VisualEffect : NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.state = .active
        return view
    }
    func updateNSView(_ view: NSView, context: Context) { }
}

@main
struct ExpediteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        Window("Expedite", id: "main") {
            if #available(macOS 15.0, *) {
                ContentView().containerBackground(.thinMaterial, for: .window)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            } else {
                ZStack {
                    Rectangle
                        .semiOpaqueWindow()
                    
                    ContentView()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
